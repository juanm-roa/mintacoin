defmodule MintacoinWeb.PaymentsControllerTest do
  @moduledoc """
  This module is used to test payments's endpoints
  """
  alias Mintacoin.Balances

  use MintacoinWeb.ConnCase
  use Oban.Testing, repo: Mintacoin.Repo

  import Mintacoin.Factory, only: [insert: 1, insert: 2]

  setup %{conn: conn} do
    Application.put_env(:mintacoin, :crypto_impl, AccountStellarMock)

    on_exit(fn ->
      Application.delete_env(:mintacoin, :crypto_impl)
    end)

    address = "GB3ZYW3WZWQU6CAEA6EQ4ALER456DPVBC6YLQRDKTTSNEVJOGFCECX5L"
    signature = "SB3RAKL2MRYZ53WJQAL5RJ42LPCMJTNDH4W7UWVRJA3GTEC66BC7VNUT"

    blockchain = insert(:blockchain, %{name: "stellar", network: "testnet"})
    account = insert(:account, %{address: address, signature: signature})

    api_token = Application.get_env(:mintacoin, :api_token)

    conn_authenticated =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer #{api_token}")

    conn_invalid_token =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer INVALID_TOKEN")

    %{
      source_account: account,
      address: address,
      signature: signature,
      blockchain: blockchain,
      conn_authenticated: conn_authenticated,
      conn_unauthenticated: put_req_header(conn, "accept", "application/json"),
      conn_invalid_token: conn_invalid_token,
      not_existing_uuid: "49354685-d6c7-4c4e-81fe-6144ab3122fa"
    }
  end

  describe "create/2" do
    setup [:create_asset, :create_payer_data]

    test "with valid params", %{conn_authenticated: conn, source_account: %{address: source_address, signature: source_signature}, blockchain: %{name: blockchain_name}} do
      conn = post(conn, Routes.payments_path(conn, :create), {
        source_signature: source_signature,
        source_address: source_address,
        destination_address: "IEJXTX2MUI26SMDNNHA7GWLTUZ55YDS7UXMFY4K3SDJ42DETDNWQ",
        amount: 60,
        asset_id: "63c2a7cf-41bc-4d3e-9a13-d27cb63a8949"
       })


      %{
        "data" => %{
          "payment_id" => _payment_id
        },
        "status" => 201
      } = json_response(conn, 201)
    end
  end

  defp create_asset(%{blockchain: blockchain}) do
    asset_code = "MTK"
    supply = "55.65"

    %{signature: signature} = account = insert(:account)

    secret_key = "SBJCNL6H5WFDK2CUAWU2IAWGWQLGER77URPYXUJ5B4N4GY2HNEBL5JJG"
    {:ok, encrypted_secret_key} = Cipher.encrypt(secret_key, signature)

    wallet =
      insert(:wallet, %{
        account: account,
        blockchain: blockchain,
        encrypted_secret_key: encrypted_secret_key
      })

    {:ok, asset} =
      Assets.create(%{
        wallet: wallet,
        signature: signature,
        asset_code: asset_code,
        asset_supply: supply
      })

    %{
      asset: asset,
      blockchain: blockchain
    }
  end

  defp create_payer_data(%{
         source_account: source_account,
         blockchain: blockchain
       }) do
    wallet =
      insert(:wallet, %{
        account: source_account,
        blockchain: blockchain
      })

    %{payer_wallet: wallet}
  end

  defp create_payer_trustline(%{
         source_account: %{signature: payer_signature} = source_account,
         payer_wallet: %{id: payer_wallet_id} = payer_wallet,
         asset: %{id: asset_id} = asset
       }) do
    {:ok, asset_holder} =
      Accounts.create_trustline(%{
        asset: asset,
        trustor_wallet: payer_wallet,
        signature: payer_signature
      })

    {:ok, %{id: balance_id}} = Balances.retrieve_by_wallet_id_and_asset_id(wallet_id, asset_id)
    {:ok, balance} = Balances.increase_balance(balance_id, "10000")

    %{payer_balance: balance}
  end
end
