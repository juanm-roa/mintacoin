defmodule Horizon.Accounts.CannedTransactions do
  @moduledoc """
  Defines horizon accounts mocks for transactions
  """

  def create(_base64_envelope) do
    {:ok,
     %Stellar.Horizon.Transaction{
       id: "ab754772dfcbeceed333d1bae5ed219d88166e0ecc897ada240cb25072076c9f",
       paging_token: "4346150421278720",
       successful: Enum.random([true, false]),
       hash: "ab754772dfcbeceed333d1bae5ed219d88166e0ecc897ada240cb25072076c9f",
       ledger: 1_011_917,
       created_at: ~U[2022-11-15 20:03:45Z],
       source_account: "GBYYS5GDK3ODHWSB6THERJMBQ25P7EM2MFQ4PP7RA6BO6DTUZKW236CD",
       source_account_sequence: 4_060_260_218_175_515,
       fee_charged: 100,
       max_fee: 100,
       operation_count: 1,
       envelope_xdr:
         "AAAAAgAAAABxiXTDVtwz2kH0zkilgYa6/5GaYWHHv/EHgu8OdMqtrQAAAGQADmzJAAAAGwAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAADNnYOf1apprLDFOnD+VVW8T209R7OMWDuNC4TT6MzhnAAAAAAX14QAAAAAAAAAAAXTKra0AAABACVRguTVLu7L16LtutKCeseBrK/8A5HnSgkq0JgC6sTF0UOqBPZZWvumBBXD8Upkz0jKlHBEjxTr1iG0iSS7QDA==",
       result_xdr: "AAAAAAAAAGQAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAA=",
       result_meta_xdr:
         "AAAAAgAAAAIAAAADAA9wzQAAAAAAAAAAcYl0w1bcM9pB9M5IpYGGuv+RmmFhx7/xB4LvDnTKra0AAAAWrX4DdAAObMkAAAAaAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAAAAAAAAAAwAAAAAAD26ZAAAAAGNysqAAAAAAAAAAAQAPcM0AAAAAAAAAAHGJdMNW3DPaQfTOSKWBhrr/kZphYce/8QeC7w50yq2tAAAAFq1+A3QADmzJAAAAGwAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAAAAAAAAAMAAAAAAA9wzQAAAABjcr40AAAAAAAAAAEAAAADAAAAAwAPcM0AAAAAAAAAAHGJdMNW3DPaQfTOSKWBhrr/kZphYce/8QeC7w50yq2tAAAAFq1+A3QADmzJAAAAGwAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAAAAAAAAAMAAAAAAA9wzQAAAABjcr40AAAAAAAAAAEAD3DNAAAAAAAAAABxiXTDVtwz2kH0zkilgYa6/5GaYWHHv/EHgu8OdMqtrQAAABaniCJ0AA5syQAAABsAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAAAAAAAAAADAAAAAAAPcM0AAAAAY3K+NAAAAAAAAAAAAA9wzQAAAAAAAAAAM2dg5/VqmmssMU6cP5VVbxPbT1Hs4xYO40LhNPozOGcAAAAABfXhAAAPcM0AAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAA",
       fee_meta_xdr:
         "AAAAAgAAAAMAD26ZAAAAAAAAAABxiXTDVtwz2kH0zkilgYa6/5GaYWHHv/EHgu8OdMqtrQAAABatfgPYAA5syQAAABoAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAAAAAAAAAADAAAAAAAPbpkAAAAAY3KyoAAAAAAAAAABAA9wzQAAAAAAAAAAcYl0w1bcM9pB9M5IpYGGuv+RmmFhx7/xB4LvDnTKra0AAAAWrX4DdAAObMkAAAAaAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAAAAAAAAAAwAAAAAAD26ZAAAAAGNysqAAAAAA",
       memo: nil,
       memo_type: "none",
       signatures: [
         "CVRguTVLu7L16LtutKCeseBrK/8A5HnSgkq0JgC6sTF0UOqBPZZWvumBBXD8Upkz0jKlHBEjxTr1iG0iSS7QDA=="
       ],
       valid_after: nil,
       valid_before: nil,
       preconditions: nil
     }}
  end

  @spec fetch_next_sequence_number(any) :: {:ok, 4_060_260_218_175_517}
  def fetch_next_sequence_number(_funder_public_key) do
    {:ok, 4_060_260_218_175_517}
  end
end