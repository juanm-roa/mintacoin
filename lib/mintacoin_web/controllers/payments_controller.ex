defmodule MintacoinWeb.PaymentsController do
  @moduledoc """
  This module contains the payment endpoints
  """

  use MintacoinWeb, :controller

  alias Ecto.{Changeset, UUID}

  alias Mintacoin.{
    Blockchain,
    Blockchains,
    Payment,
    Payments,
    Wallet,
    Wallets
  }

  @type blockchain :: Blockchain.t()
  @type conn :: Plug.Conn.t()
  @type id :: UUID.t()
  @type params :: map()
  @type resource :: Payment.t()
  @type response_status :: :created
  @type status :: :ok | :error
  @type template :: String.t()
  @type address :: String.t()
  @type blockchain_name :: String.t()
  @type wallet :: Wallet.t()
  @type network :: :testnet | :mainnet
  @type payment :: Payment.t()
  @type error ::
          :blockchain_not_found
          | :invalid_supply_format
          | :decoding_error
          | :bad_request
          | :asset_not_found
          | :wallet_not_found
          | Changeset.t()

  action_fallback MintacoinWeb.FallbackController

  @default_blockchain_name Blockchain.default()

  @spec create(conn :: conn(), params :: params()) :: conn() | {:error, error()}
  def create(
        %{assigns: %{network: network}} = conn,
        %{
          "source_signature" => _source_signature,
          "source_address" => source_address,
          "destination_address" => destination_address,
          "amount" => _amount,
          "asset_id" => _asset_id
        } = params
      ) do
    blockchain =
      Map.get(params, "blockchain", @default_blockchain_name)
      |> retrieve_blockchain(network)

    destination_wallet = retrieve_wallet(blockchain, destination_address)

    blockchain
    |> retrieve_wallet(source_address)
    |> create_payment(destination_wallet, blockchain, params)
    |> handle_response(conn, :created, "payment.json")
  end

  @spec retrieve_blockchain(blockchain_name :: blockchain_name(), network :: network()) ::
          {:ok, blockchain()} | {:error, error()}
  defp retrieve_blockchain(blockchain, network) do
    case Blockchains.retrieve(blockchain, network) do
      {:ok, %Blockchain{} = blockchain} -> {:ok, blockchain}
      _any -> {:error, :blockchain_not_found}
    end
  end

  @spec retrieve_wallet(
          blockchain :: {:ok, blockchain()} | {:error, error()},
          address :: address()
        ) ::
          {:ok, wallet()} | {:error :: error()}
  defp retrieve_wallet({:ok, %Blockchain{id: blockchain_id}}, address) do
    case Wallets.retrieve_by_account_address_and_blockchain_id(address, blockchain_id) do
      {:ok, %Wallet{} = wallet} -> {:ok, wallet}
      _any -> {:error, :wallet_not_found}
    end
  end

  defp retrieve_wallet(error, _address), do: error

  @spec create_payment(
          {:ok, wallet() | {:error, error}},
          {:ok, wallet()} | {:error, error},
          {:ok, blockchain()} | {:error, error},
          map()
        ) ::
          payment :: payment() | {:error, error}
  defp create_payment(
         {:ok, %Wallet{account_id: destination_account_id}},
         {:ok, %Wallet{account_id: source_account_id}},
         {:ok, %Blockchain{id: blockchain_id}},
         %{
           "source_signature" => source_signature,
           "amount" => amount,
           "asset_id" => asset_id
         }
       ) do
    Payments.create(%{
      source_signature: source_signature,
      source_account_id: source_account_id,
      destination_account_id: destination_account_id,
      blockchain_id: blockchain_id,
      asset_id: asset_id,
      amount: amount
    })
  end

  @spec handle_response(
          {:ok, resource :: resource()} | {:error, error()},
          conn :: conn(),
          status :: response_status(),
          template :: template()
        ) :: conn() | {:error, error()}
  defp handle_response({:ok, resource}, conn, status, template) do
    conn
    |> put_status(status)
    |> render(template, resource: resource)
  end

  defp handle_response({:error, error}, _conn, _status, _template), do: {:error, error}
end
