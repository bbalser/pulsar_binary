defmodule Pulsar.Proto.Schema do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          name: String.t(),
          schema_data: binary,
          type: atom | integer,
          properties: [Pulsar.Proto.KeyValue.t()]
        }
  defstruct [:name, :schema_data, :type, :properties]

  field(:name, 1, required: true, type: :string)
  field(:schema_data, 3, required: true, type: :bytes)
  field(:type, 4, required: true, type: Pulsar.Proto.Schema.Type, enum: true)
  field(:properties, 5, repeated: true, type: Pulsar.Proto.KeyValue)
end

defmodule Pulsar.Proto.Schema.Type do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto2

  field(:None, 0)
  field(:String, 1)
  field(:Json, 2)
  field(:Protobuf, 3)
  field(:Avro, 4)
  field(:Bool, 5)
  field(:Int8, 6)
  field(:Int16, 7)
  field(:Int32, 8)
  field(:Int64, 9)
  field(:Float, 10)
  field(:Double, 11)
  field(:Date, 12)
  field(:Time, 13)
  field(:Timestamp, 14)
  field(:KeyValue, 15)
end

defmodule Pulsar.Proto.MessageIdData do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          ledgerId: non_neg_integer,
          entryId: non_neg_integer,
          partition: integer,
          batch_index: integer
        }
  defstruct [:ledgerId, :entryId, :partition, :batch_index]

  field(:ledgerId, 1, required: true, type: :uint64)
  field(:entryId, 2, required: true, type: :uint64)
  field(:partition, 3, optional: true, type: :int32, default: -1)
  field(:batch_index, 4, optional: true, type: :int32, default: -1)
end

defmodule Pulsar.Proto.KeyValue do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          key: String.t(),
          value: String.t()
        }
  defstruct [:key, :value]

  field(:key, 1, required: true, type: :string)
  field(:value, 2, required: true, type: :string)
end

defmodule Pulsar.Proto.KeyLongValue do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          key: String.t(),
          value: non_neg_integer
        }
  defstruct [:key, :value]

  field(:key, 1, required: true, type: :string)
  field(:value, 2, required: true, type: :uint64)
end

defmodule Pulsar.Proto.IntRange do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          start: integer,
          end: integer
        }
  defstruct [:start, :end]

  field(:start, 1, required: true, type: :int32)
  field(:end, 2, required: true, type: :int32)
end

defmodule Pulsar.Proto.EncryptionKeys do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          key: String.t(),
          value: binary,
          metadata: [Pulsar.Proto.KeyValue.t()]
        }
  defstruct [:key, :value, :metadata]

  field(:key, 1, required: true, type: :string)
  field(:value, 2, required: true, type: :bytes)
  field(:metadata, 3, repeated: true, type: Pulsar.Proto.KeyValue)
end

defmodule Pulsar.Proto.MessageMetadata do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          producer_name: String.t(),
          sequence_id: non_neg_integer,
          publish_time: non_neg_integer,
          properties: [Pulsar.Proto.KeyValue.t()],
          replicated_from: String.t(),
          partition_key: String.t(),
          replicate_to: [String.t()],
          compression: atom | integer,
          uncompressed_size: non_neg_integer,
          num_messages_in_batch: integer,
          event_time: non_neg_integer,
          encryption_keys: [Pulsar.Proto.EncryptionKeys.t()],
          encryption_algo: String.t(),
          encryption_param: binary,
          schema_version: binary,
          partition_key_b64_encoded: boolean,
          ordering_key: binary,
          deliver_at_time: integer,
          marker_type: integer,
          txnid_least_bits: non_neg_integer,
          txnid_most_bits: non_neg_integer,
          highest_sequence_id: non_neg_integer
        }
  defstruct [
    :producer_name,
    :sequence_id,
    :publish_time,
    :properties,
    :replicated_from,
    :partition_key,
    :replicate_to,
    :compression,
    :uncompressed_size,
    :num_messages_in_batch,
    :event_time,
    :encryption_keys,
    :encryption_algo,
    :encryption_param,
    :schema_version,
    :partition_key_b64_encoded,
    :ordering_key,
    :deliver_at_time,
    :marker_type,
    :txnid_least_bits,
    :txnid_most_bits,
    :highest_sequence_id
  ]

  field(:producer_name, 1, required: true, type: :string)
  field(:sequence_id, 2, required: true, type: :uint64)
  field(:publish_time, 3, required: true, type: :uint64)
  field(:properties, 4, repeated: true, type: Pulsar.Proto.KeyValue)
  field(:replicated_from, 5, optional: true, type: :string)
  field(:partition_key, 6, optional: true, type: :string)
  field(:replicate_to, 7, repeated: true, type: :string)

  field(:compression, 8,
    optional: true,
    type: Pulsar.Proto.CompressionType,
    default: :NONE,
    enum: true
  )

  field(:uncompressed_size, 9, optional: true, type: :uint32, default: 0)
  field(:num_messages_in_batch, 11, optional: true, type: :int32, default: 1)
  field(:event_time, 12, optional: true, type: :uint64, default: 0)
  field(:encryption_keys, 13, repeated: true, type: Pulsar.Proto.EncryptionKeys)
  field(:encryption_algo, 14, optional: true, type: :string)
  field(:encryption_param, 15, optional: true, type: :bytes)
  field(:schema_version, 16, optional: true, type: :bytes)
  field(:partition_key_b64_encoded, 17, optional: true, type: :bool, default: false)
  field(:ordering_key, 18, optional: true, type: :bytes)
  field(:deliver_at_time, 19, optional: true, type: :int64)
  field(:marker_type, 20, optional: true, type: :int32)
  field(:txnid_least_bits, 22, optional: true, type: :uint64, default: 0)
  field(:txnid_most_bits, 23, optional: true, type: :uint64, default: 0)
  field(:highest_sequence_id, 24, optional: true, type: :uint64, default: 0)
end

defmodule Pulsar.Proto.SingleMessageMetadata do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          properties: [Pulsar.Proto.KeyValue.t()],
          partition_key: String.t(),
          payload_size: integer,
          compacted_out: boolean,
          event_time: non_neg_integer,
          partition_key_b64_encoded: boolean,
          ordering_key: binary,
          sequence_id: non_neg_integer
        }
  defstruct [
    :properties,
    :partition_key,
    :payload_size,
    :compacted_out,
    :event_time,
    :partition_key_b64_encoded,
    :ordering_key,
    :sequence_id
  ]

  field(:properties, 1, repeated: true, type: Pulsar.Proto.KeyValue)
  field(:partition_key, 2, optional: true, type: :string)
  field(:payload_size, 3, required: true, type: :int32)
  field(:compacted_out, 4, optional: true, type: :bool, default: false)
  field(:event_time, 5, optional: true, type: :uint64, default: 0)
  field(:partition_key_b64_encoded, 6, optional: true, type: :bool, default: false)
  field(:ordering_key, 7, optional: true, type: :bytes)
  field(:sequence_id, 8, optional: true, type: :uint64)
end

defmodule Pulsar.Proto.CommandConnect do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          client_version: String.t(),
          auth_method: atom | integer,
          auth_method_name: String.t(),
          auth_data: binary,
          protocol_version: integer,
          proxy_to_broker_url: String.t(),
          original_principal: String.t(),
          original_auth_data: String.t(),
          original_auth_method: String.t()
        }
  defstruct [
    :client_version,
    :auth_method,
    :auth_method_name,
    :auth_data,
    :protocol_version,
    :proxy_to_broker_url,
    :original_principal,
    :original_auth_data,
    :original_auth_method
  ]

  field(:client_version, 1, required: true, type: :string)
  field(:auth_method, 2, optional: true, type: Pulsar.Proto.AuthMethod, enum: true)
  field(:auth_method_name, 5, optional: true, type: :string)
  field(:auth_data, 3, optional: true, type: :bytes)
  field(:protocol_version, 4, optional: true, type: :int32, default: 0)
  field(:proxy_to_broker_url, 6, optional: true, type: :string)
  field(:original_principal, 7, optional: true, type: :string)
  field(:original_auth_data, 8, optional: true, type: :string)
  field(:original_auth_method, 9, optional: true, type: :string)
end

defmodule Pulsar.Proto.CommandConnected do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          server_version: String.t(),
          protocol_version: integer,
          max_message_size: integer
        }
  defstruct [:server_version, :protocol_version, :max_message_size]

  field(:server_version, 1, required: true, type: :string)
  field(:protocol_version, 2, optional: true, type: :int32, default: 0)
  field(:max_message_size, 3, optional: true, type: :int32)
end

defmodule Pulsar.Proto.CommandAuthResponse do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          client_version: String.t(),
          response: Pulsar.Proto.AuthData.t() | nil,
          protocol_version: integer
        }
  defstruct [:client_version, :response, :protocol_version]

  field(:client_version, 1, optional: true, type: :string)
  field(:response, 2, optional: true, type: Pulsar.Proto.AuthData)
  field(:protocol_version, 3, optional: true, type: :int32, default: 0)
end

defmodule Pulsar.Proto.CommandAuthChallenge do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          server_version: String.t(),
          challenge: Pulsar.Proto.AuthData.t() | nil,
          protocol_version: integer
        }
  defstruct [:server_version, :challenge, :protocol_version]

  field(:server_version, 1, optional: true, type: :string)
  field(:challenge, 2, optional: true, type: Pulsar.Proto.AuthData)
  field(:protocol_version, 3, optional: true, type: :int32, default: 0)
end

defmodule Pulsar.Proto.AuthData do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          auth_method_name: String.t(),
          auth_data: binary
        }
  defstruct [:auth_method_name, :auth_data]

  field(:auth_method_name, 1, optional: true, type: :string)
  field(:auth_data, 2, optional: true, type: :bytes)
end

defmodule Pulsar.Proto.KeySharedMeta do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          keySharedMode: atom | integer,
          hashRanges: [Pulsar.Proto.IntRange.t()]
        }
  defstruct [:keySharedMode, :hashRanges]

  field(:keySharedMode, 1, required: true, type: Pulsar.Proto.KeySharedMode, enum: true)
  field(:hashRanges, 3, repeated: true, type: Pulsar.Proto.IntRange)
end

defmodule Pulsar.Proto.CommandSubscribe do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          topic: String.t(),
          subscription: String.t(),
          subType: atom | integer,
          consumer_id: non_neg_integer,
          request_id: non_neg_integer,
          consumer_name: String.t(),
          priority_level: integer,
          durable: boolean,
          start_message_id: Pulsar.Proto.MessageIdData.t() | nil,
          metadata: [Pulsar.Proto.KeyValue.t()],
          read_compacted: boolean,
          schema: Pulsar.Proto.Schema.t() | nil,
          initialPosition: atom | integer,
          replicate_subscription_state: boolean,
          force_topic_creation: boolean,
          start_message_rollback_duration_sec: non_neg_integer,
          keySharedMeta: Pulsar.Proto.KeySharedMeta.t() | nil
        }
  defstruct [
    :topic,
    :subscription,
    :subType,
    :consumer_id,
    :request_id,
    :consumer_name,
    :priority_level,
    :durable,
    :start_message_id,
    :metadata,
    :read_compacted,
    :schema,
    :initialPosition,
    :replicate_subscription_state,
    :force_topic_creation,
    :start_message_rollback_duration_sec,
    :keySharedMeta
  ]

  field(:topic, 1, required: true, type: :string)
  field(:subscription, 2, required: true, type: :string)
  field(:subType, 3, required: true, type: Pulsar.Proto.CommandSubscribe.SubType, enum: true)
  field(:consumer_id, 4, required: true, type: :uint64)
  field(:request_id, 5, required: true, type: :uint64)
  field(:consumer_name, 6, optional: true, type: :string)
  field(:priority_level, 7, optional: true, type: :int32)
  field(:durable, 8, optional: true, type: :bool, default: true)
  field(:start_message_id, 9, optional: true, type: Pulsar.Proto.MessageIdData)
  field(:metadata, 10, repeated: true, type: Pulsar.Proto.KeyValue)
  field(:read_compacted, 11, optional: true, type: :bool)
  field(:schema, 12, optional: true, type: Pulsar.Proto.Schema)

  field(:initialPosition, 13,
    optional: true,
    type: Pulsar.Proto.CommandSubscribe.InitialPosition,
    default: :Latest,
    enum: true
  )

  field(:replicate_subscription_state, 14, optional: true, type: :bool)
  field(:force_topic_creation, 15, optional: true, type: :bool, default: true)
  field(:start_message_rollback_duration_sec, 16, optional: true, type: :uint64, default: 0)
  field(:keySharedMeta, 17, optional: true, type: Pulsar.Proto.KeySharedMeta)
end

defmodule Pulsar.Proto.CommandSubscribe.SubType do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto2

  field(:Exclusive, 0)
  field(:Shared, 1)
  field(:Failover, 2)
  field(:Key_Shared, 3)
end

defmodule Pulsar.Proto.CommandSubscribe.InitialPosition do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto2

  field(:Latest, 0)
  field(:Earliest, 1)
end

defmodule Pulsar.Proto.CommandPartitionedTopicMetadata do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          topic: String.t(),
          request_id: non_neg_integer,
          original_principal: String.t(),
          original_auth_data: String.t(),
          original_auth_method: String.t()
        }
  defstruct [:topic, :request_id, :original_principal, :original_auth_data, :original_auth_method]

  field(:topic, 1, required: true, type: :string)
  field(:request_id, 2, required: true, type: :uint64)
  field(:original_principal, 3, optional: true, type: :string)
  field(:original_auth_data, 4, optional: true, type: :string)
  field(:original_auth_method, 5, optional: true, type: :string)
end

defmodule Pulsar.Proto.CommandPartitionedTopicMetadataResponse do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          partitions: non_neg_integer,
          request_id: non_neg_integer,
          response: atom | integer,
          error: atom | integer,
          message: String.t()
        }
  defstruct [:partitions, :request_id, :response, :error, :message]

  field(:partitions, 1, optional: true, type: :uint32)
  field(:request_id, 2, required: true, type: :uint64)

  field(:response, 3,
    optional: true,
    type: Pulsar.Proto.CommandPartitionedTopicMetadataResponse.LookupType,
    enum: true
  )

  field(:error, 4, optional: true, type: Pulsar.Proto.ServerError, enum: true)
  field(:message, 5, optional: true, type: :string)
end

defmodule Pulsar.Proto.CommandPartitionedTopicMetadataResponse.LookupType do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto2

  field(:Success, 0)
  field(:Failed, 1)
end

defmodule Pulsar.Proto.CommandLookupTopic do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          topic: String.t(),
          request_id: non_neg_integer,
          authoritative: boolean,
          original_principal: String.t(),
          original_auth_data: String.t(),
          original_auth_method: String.t()
        }
  defstruct [
    :topic,
    :request_id,
    :authoritative,
    :original_principal,
    :original_auth_data,
    :original_auth_method
  ]

  field(:topic, 1, required: true, type: :string)
  field(:request_id, 2, required: true, type: :uint64)
  field(:authoritative, 3, optional: true, type: :bool, default: false)
  field(:original_principal, 4, optional: true, type: :string)
  field(:original_auth_data, 5, optional: true, type: :string)
  field(:original_auth_method, 6, optional: true, type: :string)
end

defmodule Pulsar.Proto.CommandLookupTopicResponse do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          brokerServiceUrl: String.t(),
          brokerServiceUrlTls: String.t(),
          response: atom | integer,
          request_id: non_neg_integer,
          authoritative: boolean,
          error: atom | integer,
          message: String.t(),
          proxy_through_service_url: boolean
        }
  defstruct [
    :brokerServiceUrl,
    :brokerServiceUrlTls,
    :response,
    :request_id,
    :authoritative,
    :error,
    :message,
    :proxy_through_service_url
  ]

  field(:brokerServiceUrl, 1, optional: true, type: :string)
  field(:brokerServiceUrlTls, 2, optional: true, type: :string)

  field(:response, 3,
    optional: true,
    type: Pulsar.Proto.CommandLookupTopicResponse.LookupType,
    enum: true
  )

  field(:request_id, 4, required: true, type: :uint64)
  field(:authoritative, 5, optional: true, type: :bool, default: false)
  field(:error, 6, optional: true, type: Pulsar.Proto.ServerError, enum: true)
  field(:message, 7, optional: true, type: :string)
  field(:proxy_through_service_url, 8, optional: true, type: :bool, default: false)
end

defmodule Pulsar.Proto.CommandLookupTopicResponse.LookupType do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto2

  field(:Redirect, 0)
  field(:Connect, 1)
  field(:Failed, 2)
end

defmodule Pulsar.Proto.CommandProducer do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          topic: String.t(),
          producer_id: non_neg_integer,
          request_id: non_neg_integer,
          producer_name: String.t(),
          encrypted: boolean,
          metadata: [Pulsar.Proto.KeyValue.t()],
          schema: Pulsar.Proto.Schema.t() | nil,
          epoch: non_neg_integer,
          user_provided_producer_name: boolean
        }
  defstruct [
    :topic,
    :producer_id,
    :request_id,
    :producer_name,
    :encrypted,
    :metadata,
    :schema,
    :epoch,
    :user_provided_producer_name
  ]

  field(:topic, 1, required: true, type: :string)
  field(:producer_id, 2, required: true, type: :uint64)
  field(:request_id, 3, required: true, type: :uint64)
  field(:producer_name, 4, optional: true, type: :string)
  field(:encrypted, 5, optional: true, type: :bool, default: false)
  field(:metadata, 6, repeated: true, type: Pulsar.Proto.KeyValue)
  field(:schema, 7, optional: true, type: Pulsar.Proto.Schema)
  field(:epoch, 8, optional: true, type: :uint64, default: 0)
  field(:user_provided_producer_name, 9, optional: true, type: :bool, default: true)
end

defmodule Pulsar.Proto.CommandSend do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          producer_id: non_neg_integer,
          sequence_id: non_neg_integer,
          num_messages: integer,
          txnid_least_bits: non_neg_integer,
          txnid_most_bits: non_neg_integer,
          highest_sequence_id: non_neg_integer
        }
  defstruct [
    :producer_id,
    :sequence_id,
    :num_messages,
    :txnid_least_bits,
    :txnid_most_bits,
    :highest_sequence_id
  ]

  field(:producer_id, 1, required: true, type: :uint64)
  field(:sequence_id, 2, required: true, type: :uint64)
  field(:num_messages, 3, optional: true, type: :int32, default: 1)
  field(:txnid_least_bits, 4, optional: true, type: :uint64, default: 0)
  field(:txnid_most_bits, 5, optional: true, type: :uint64, default: 0)
  field(:highest_sequence_id, 6, optional: true, type: :uint64, default: 0)
end

defmodule Pulsar.Proto.CommandSendReceipt do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          producer_id: non_neg_integer,
          sequence_id: non_neg_integer,
          message_id: Pulsar.Proto.MessageIdData.t() | nil,
          highest_sequence_id: non_neg_integer
        }
  defstruct [:producer_id, :sequence_id, :message_id, :highest_sequence_id]

  field(:producer_id, 1, required: true, type: :uint64)
  field(:sequence_id, 2, required: true, type: :uint64)
  field(:message_id, 3, optional: true, type: Pulsar.Proto.MessageIdData)
  field(:highest_sequence_id, 4, optional: true, type: :uint64, default: 0)
end

defmodule Pulsar.Proto.CommandSendError do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          producer_id: non_neg_integer,
          sequence_id: non_neg_integer,
          error: atom | integer,
          message: String.t()
        }
  defstruct [:producer_id, :sequence_id, :error, :message]

  field(:producer_id, 1, required: true, type: :uint64)
  field(:sequence_id, 2, required: true, type: :uint64)
  field(:error, 3, required: true, type: Pulsar.Proto.ServerError, enum: true)
  field(:message, 4, required: true, type: :string)
end

defmodule Pulsar.Proto.CommandMessage do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          consumer_id: non_neg_integer,
          message_id: Pulsar.Proto.MessageIdData.t() | nil,
          redelivery_count: non_neg_integer
        }
  defstruct [:consumer_id, :message_id, :redelivery_count]

  field(:consumer_id, 1, required: true, type: :uint64)
  field(:message_id, 2, required: true, type: Pulsar.Proto.MessageIdData)
  field(:redelivery_count, 3, optional: true, type: :uint32, default: 0)
end

defmodule Pulsar.Proto.CommandAck do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          consumer_id: non_neg_integer,
          ack_type: atom | integer,
          message_id: [Pulsar.Proto.MessageIdData.t()],
          validation_error: atom | integer,
          properties: [Pulsar.Proto.KeyLongValue.t()],
          txnid_least_bits: non_neg_integer,
          txnid_most_bits: non_neg_integer
        }
  defstruct [
    :consumer_id,
    :ack_type,
    :message_id,
    :validation_error,
    :properties,
    :txnid_least_bits,
    :txnid_most_bits
  ]

  field(:consumer_id, 1, required: true, type: :uint64)
  field(:ack_type, 2, required: true, type: Pulsar.Proto.CommandAck.AckType, enum: true)
  field(:message_id, 3, repeated: true, type: Pulsar.Proto.MessageIdData)

  field(:validation_error, 4,
    optional: true,
    type: Pulsar.Proto.CommandAck.ValidationError,
    enum: true
  )

  field(:properties, 5, repeated: true, type: Pulsar.Proto.KeyLongValue)
  field(:txnid_least_bits, 6, optional: true, type: :uint64, default: 0)
  field(:txnid_most_bits, 7, optional: true, type: :uint64, default: 0)
end

defmodule Pulsar.Proto.CommandAck.AckType do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto2

  field(:Individual, 0)
  field(:Cumulative, 1)
end

defmodule Pulsar.Proto.CommandAck.ValidationError do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto2

  field(:UncompressedSizeCorruption, 0)
  field(:DecompressionError, 1)
  field(:ChecksumMismatch, 2)
  field(:BatchDeSerializeError, 3)
  field(:DecryptionError, 4)
end

defmodule Pulsar.Proto.CommandAckResponse do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          consumer_id: non_neg_integer,
          txnid_least_bits: non_neg_integer,
          txnid_most_bits: non_neg_integer,
          error: atom | integer,
          message: String.t()
        }
  defstruct [:consumer_id, :txnid_least_bits, :txnid_most_bits, :error, :message]

  field(:consumer_id, 1, required: true, type: :uint64)
  field(:txnid_least_bits, 2, optional: true, type: :uint64, default: 0)
  field(:txnid_most_bits, 3, optional: true, type: :uint64, default: 0)
  field(:error, 4, optional: true, type: Pulsar.Proto.ServerError, enum: true)
  field(:message, 5, optional: true, type: :string)
end

defmodule Pulsar.Proto.CommandActiveConsumerChange do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          consumer_id: non_neg_integer,
          is_active: boolean
        }
  defstruct [:consumer_id, :is_active]

  field(:consumer_id, 1, required: true, type: :uint64)
  field(:is_active, 2, optional: true, type: :bool, default: false)
end

defmodule Pulsar.Proto.CommandFlow do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          consumer_id: non_neg_integer,
          messagePermits: non_neg_integer
        }
  defstruct [:consumer_id, :messagePermits]

  field(:consumer_id, 1, required: true, type: :uint64)
  field(:messagePermits, 2, required: true, type: :uint32)
end

defmodule Pulsar.Proto.CommandUnsubscribe do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          consumer_id: non_neg_integer,
          request_id: non_neg_integer
        }
  defstruct [:consumer_id, :request_id]

  field(:consumer_id, 1, required: true, type: :uint64)
  field(:request_id, 2, required: true, type: :uint64)
end

defmodule Pulsar.Proto.CommandSeek do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          consumer_id: non_neg_integer,
          request_id: non_neg_integer,
          message_id: Pulsar.Proto.MessageIdData.t() | nil,
          message_publish_time: non_neg_integer
        }
  defstruct [:consumer_id, :request_id, :message_id, :message_publish_time]

  field(:consumer_id, 1, required: true, type: :uint64)
  field(:request_id, 2, required: true, type: :uint64)
  field(:message_id, 3, optional: true, type: Pulsar.Proto.MessageIdData)
  field(:message_publish_time, 4, optional: true, type: :uint64)
end

defmodule Pulsar.Proto.CommandReachedEndOfTopic do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          consumer_id: non_neg_integer
        }
  defstruct [:consumer_id]

  field(:consumer_id, 1, required: true, type: :uint64)
end

defmodule Pulsar.Proto.CommandCloseProducer do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          producer_id: non_neg_integer,
          request_id: non_neg_integer
        }
  defstruct [:producer_id, :request_id]

  field(:producer_id, 1, required: true, type: :uint64)
  field(:request_id, 2, required: true, type: :uint64)
end

defmodule Pulsar.Proto.CommandCloseConsumer do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          consumer_id: non_neg_integer,
          request_id: non_neg_integer
        }
  defstruct [:consumer_id, :request_id]

  field(:consumer_id, 1, required: true, type: :uint64)
  field(:request_id, 2, required: true, type: :uint64)
end

defmodule Pulsar.Proto.CommandRedeliverUnacknowledgedMessages do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          consumer_id: non_neg_integer,
          message_ids: [Pulsar.Proto.MessageIdData.t()]
        }
  defstruct [:consumer_id, :message_ids]

  field(:consumer_id, 1, required: true, type: :uint64)
  field(:message_ids, 2, repeated: true, type: Pulsar.Proto.MessageIdData)
end

defmodule Pulsar.Proto.CommandSuccess do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          request_id: non_neg_integer,
          schema: Pulsar.Proto.Schema.t() | nil
        }
  defstruct [:request_id, :schema]

  field(:request_id, 1, required: true, type: :uint64)
  field(:schema, 2, optional: true, type: Pulsar.Proto.Schema)
end

defmodule Pulsar.Proto.CommandProducerSuccess do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          request_id: non_neg_integer,
          producer_name: String.t(),
          last_sequence_id: integer,
          schema_version: binary
        }
  defstruct [:request_id, :producer_name, :last_sequence_id, :schema_version]

  field(:request_id, 1, required: true, type: :uint64)
  field(:producer_name, 2, required: true, type: :string)
  field(:last_sequence_id, 3, optional: true, type: :int64, default: -1)
  field(:schema_version, 4, optional: true, type: :bytes)
end

defmodule Pulsar.Proto.CommandError do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          request_id: non_neg_integer,
          error: atom | integer,
          message: String.t()
        }
  defstruct [:request_id, :error, :message]

  field(:request_id, 1, required: true, type: :uint64)
  field(:error, 2, required: true, type: Pulsar.Proto.ServerError, enum: true)
  field(:message, 3, required: true, type: :string)
end

defmodule Pulsar.Proto.CommandPing do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{}
  defstruct []
end

defmodule Pulsar.Proto.CommandPong do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{}
  defstruct []
end

defmodule Pulsar.Proto.CommandConsumerStats do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          request_id: non_neg_integer,
          consumer_id: non_neg_integer
        }
  defstruct [:request_id, :consumer_id]

  field(:request_id, 1, required: true, type: :uint64)
  field(:consumer_id, 4, required: true, type: :uint64)
end

defmodule Pulsar.Proto.CommandConsumerStatsResponse do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          request_id: non_neg_integer,
          error_code: atom | integer,
          error_message: String.t(),
          msgRateOut: float | :infinity | :negative_infinity | :nan,
          msgThroughputOut: float | :infinity | :negative_infinity | :nan,
          msgRateRedeliver: float | :infinity | :negative_infinity | :nan,
          consumerName: String.t(),
          availablePermits: non_neg_integer,
          unackedMessages: non_neg_integer,
          blockedConsumerOnUnackedMsgs: boolean,
          address: String.t(),
          connectedSince: String.t(),
          type: String.t(),
          msgRateExpired: float | :infinity | :negative_infinity | :nan,
          msgBacklog: non_neg_integer
        }
  defstruct [
    :request_id,
    :error_code,
    :error_message,
    :msgRateOut,
    :msgThroughputOut,
    :msgRateRedeliver,
    :consumerName,
    :availablePermits,
    :unackedMessages,
    :blockedConsumerOnUnackedMsgs,
    :address,
    :connectedSince,
    :type,
    :msgRateExpired,
    :msgBacklog
  ]

  field(:request_id, 1, required: true, type: :uint64)
  field(:error_code, 2, optional: true, type: Pulsar.Proto.ServerError, enum: true)
  field(:error_message, 3, optional: true, type: :string)
  field(:msgRateOut, 4, optional: true, type: :double)
  field(:msgThroughputOut, 5, optional: true, type: :double)
  field(:msgRateRedeliver, 6, optional: true, type: :double)
  field(:consumerName, 7, optional: true, type: :string)
  field(:availablePermits, 8, optional: true, type: :uint64)
  field(:unackedMessages, 9, optional: true, type: :uint64)
  field(:blockedConsumerOnUnackedMsgs, 10, optional: true, type: :bool)
  field(:address, 11, optional: true, type: :string)
  field(:connectedSince, 12, optional: true, type: :string)
  field(:type, 13, optional: true, type: :string)
  field(:msgRateExpired, 14, optional: true, type: :double)
  field(:msgBacklog, 15, optional: true, type: :uint64)
end

defmodule Pulsar.Proto.CommandGetLastMessageId do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          consumer_id: non_neg_integer,
          request_id: non_neg_integer
        }
  defstruct [:consumer_id, :request_id]

  field(:consumer_id, 1, required: true, type: :uint64)
  field(:request_id, 2, required: true, type: :uint64)
end

defmodule Pulsar.Proto.CommandGetLastMessageIdResponse do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          last_message_id: Pulsar.Proto.MessageIdData.t() | nil,
          request_id: non_neg_integer
        }
  defstruct [:last_message_id, :request_id]

  field(:last_message_id, 1, required: true, type: Pulsar.Proto.MessageIdData)
  field(:request_id, 2, required: true, type: :uint64)
end

defmodule Pulsar.Proto.CommandGetTopicsOfNamespace do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          request_id: non_neg_integer,
          namespace: String.t(),
          mode: atom | integer
        }
  defstruct [:request_id, :namespace, :mode]

  field(:request_id, 1, required: true, type: :uint64)
  field(:namespace, 2, required: true, type: :string)

  field(:mode, 3,
    optional: true,
    type: Pulsar.Proto.CommandGetTopicsOfNamespace.Mode,
    default: :PERSISTENT,
    enum: true
  )
end

defmodule Pulsar.Proto.CommandGetTopicsOfNamespace.Mode do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto2

  field(:PERSISTENT, 0)
  field(:NON_PERSISTENT, 1)
  field(:ALL, 2)
end

defmodule Pulsar.Proto.CommandGetTopicsOfNamespaceResponse do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          request_id: non_neg_integer,
          topics: [String.t()]
        }
  defstruct [:request_id, :topics]

  field(:request_id, 1, required: true, type: :uint64)
  field(:topics, 2, repeated: true, type: :string)
end

defmodule Pulsar.Proto.CommandGetSchema do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          request_id: non_neg_integer,
          topic: String.t(),
          schema_version: binary
        }
  defstruct [:request_id, :topic, :schema_version]

  field(:request_id, 1, required: true, type: :uint64)
  field(:topic, 2, required: true, type: :string)
  field(:schema_version, 3, optional: true, type: :bytes)
end

defmodule Pulsar.Proto.CommandGetSchemaResponse do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          request_id: non_neg_integer,
          error_code: atom | integer,
          error_message: String.t(),
          schema: Pulsar.Proto.Schema.t() | nil,
          schema_version: binary
        }
  defstruct [:request_id, :error_code, :error_message, :schema, :schema_version]

  field(:request_id, 1, required: true, type: :uint64)
  field(:error_code, 2, optional: true, type: Pulsar.Proto.ServerError, enum: true)
  field(:error_message, 3, optional: true, type: :string)
  field(:schema, 4, optional: true, type: Pulsar.Proto.Schema)
  field(:schema_version, 5, optional: true, type: :bytes)
end

defmodule Pulsar.Proto.CommandGetOrCreateSchema do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          request_id: non_neg_integer,
          topic: String.t(),
          schema: Pulsar.Proto.Schema.t() | nil
        }
  defstruct [:request_id, :topic, :schema]

  field(:request_id, 1, required: true, type: :uint64)
  field(:topic, 2, required: true, type: :string)
  field(:schema, 3, required: true, type: Pulsar.Proto.Schema)
end

defmodule Pulsar.Proto.CommandGetOrCreateSchemaResponse do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          request_id: non_neg_integer,
          error_code: atom | integer,
          error_message: String.t(),
          schema_version: binary
        }
  defstruct [:request_id, :error_code, :error_message, :schema_version]

  field(:request_id, 1, required: true, type: :uint64)
  field(:error_code, 2, optional: true, type: Pulsar.Proto.ServerError, enum: true)
  field(:error_message, 3, optional: true, type: :string)
  field(:schema_version, 4, optional: true, type: :bytes)
end

defmodule Pulsar.Proto.CommandNewTxn do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          request_id: non_neg_integer,
          txn_ttl_seconds: non_neg_integer
        }
  defstruct [:request_id, :txn_ttl_seconds]

  field(:request_id, 1, required: true, type: :uint64)
  field(:txn_ttl_seconds, 2, optional: true, type: :uint64, default: 0)
end

defmodule Pulsar.Proto.CommandNewTxnResponse do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          request_id: non_neg_integer,
          txnid_least_bits: non_neg_integer,
          txnid_most_bits: non_neg_integer,
          error: atom | integer,
          message: String.t()
        }
  defstruct [:request_id, :txnid_least_bits, :txnid_most_bits, :error, :message]

  field(:request_id, 1, required: true, type: :uint64)
  field(:txnid_least_bits, 2, optional: true, type: :uint64, default: 0)
  field(:txnid_most_bits, 3, optional: true, type: :uint64, default: 0)
  field(:error, 4, optional: true, type: Pulsar.Proto.ServerError, enum: true)
  field(:message, 5, optional: true, type: :string)
end

defmodule Pulsar.Proto.CommandAddPartitionToTxn do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          request_id: non_neg_integer,
          txnid_least_bits: non_neg_integer,
          txnid_most_bits: non_neg_integer,
          partitions: [String.t()]
        }
  defstruct [:request_id, :txnid_least_bits, :txnid_most_bits, :partitions]

  field(:request_id, 1, required: true, type: :uint64)
  field(:txnid_least_bits, 2, optional: true, type: :uint64, default: 0)
  field(:txnid_most_bits, 3, optional: true, type: :uint64, default: 0)
  field(:partitions, 4, repeated: true, type: :string)
end

defmodule Pulsar.Proto.CommandAddPartitionToTxnResponse do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          request_id: non_neg_integer,
          txnid_least_bits: non_neg_integer,
          txnid_most_bits: non_neg_integer,
          error: atom | integer,
          message: String.t()
        }
  defstruct [:request_id, :txnid_least_bits, :txnid_most_bits, :error, :message]

  field(:request_id, 1, required: true, type: :uint64)
  field(:txnid_least_bits, 2, optional: true, type: :uint64, default: 0)
  field(:txnid_most_bits, 3, optional: true, type: :uint64, default: 0)
  field(:error, 4, optional: true, type: Pulsar.Proto.ServerError, enum: true)
  field(:message, 5, optional: true, type: :string)
end

defmodule Pulsar.Proto.Subscription do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          topic: String.t(),
          subscription: String.t()
        }
  defstruct [:topic, :subscription]

  field(:topic, 1, required: true, type: :string)
  field(:subscription, 2, required: true, type: :string)
end

defmodule Pulsar.Proto.CommandAddSubscriptionToTxn do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          request_id: non_neg_integer,
          txnid_least_bits: non_neg_integer,
          txnid_most_bits: non_neg_integer,
          subscription: [Pulsar.Proto.Subscription.t()]
        }
  defstruct [:request_id, :txnid_least_bits, :txnid_most_bits, :subscription]

  field(:request_id, 1, required: true, type: :uint64)
  field(:txnid_least_bits, 2, optional: true, type: :uint64, default: 0)
  field(:txnid_most_bits, 3, optional: true, type: :uint64, default: 0)
  field(:subscription, 4, repeated: true, type: Pulsar.Proto.Subscription)
end

defmodule Pulsar.Proto.CommandAddSubscriptionToTxnResponse do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          request_id: non_neg_integer,
          txnid_least_bits: non_neg_integer,
          txnid_most_bits: non_neg_integer,
          error: atom | integer,
          message: String.t()
        }
  defstruct [:request_id, :txnid_least_bits, :txnid_most_bits, :error, :message]

  field(:request_id, 1, required: true, type: :uint64)
  field(:txnid_least_bits, 2, optional: true, type: :uint64, default: 0)
  field(:txnid_most_bits, 3, optional: true, type: :uint64, default: 0)
  field(:error, 4, optional: true, type: Pulsar.Proto.ServerError, enum: true)
  field(:message, 5, optional: true, type: :string)
end

defmodule Pulsar.Proto.CommandEndTxn do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          request_id: non_neg_integer,
          txnid_least_bits: non_neg_integer,
          txnid_most_bits: non_neg_integer,
          txn_action: atom | integer
        }
  defstruct [:request_id, :txnid_least_bits, :txnid_most_bits, :txn_action]

  field(:request_id, 1, required: true, type: :uint64)
  field(:txnid_least_bits, 2, optional: true, type: :uint64, default: 0)
  field(:txnid_most_bits, 3, optional: true, type: :uint64, default: 0)
  field(:txn_action, 4, optional: true, type: Pulsar.Proto.TxnAction, enum: true)
end

defmodule Pulsar.Proto.CommandEndTxnResponse do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          request_id: non_neg_integer,
          txnid_least_bits: non_neg_integer,
          txnid_most_bits: non_neg_integer,
          error: atom | integer,
          message: String.t()
        }
  defstruct [:request_id, :txnid_least_bits, :txnid_most_bits, :error, :message]

  field(:request_id, 1, required: true, type: :uint64)
  field(:txnid_least_bits, 2, optional: true, type: :uint64, default: 0)
  field(:txnid_most_bits, 3, optional: true, type: :uint64, default: 0)
  field(:error, 4, optional: true, type: Pulsar.Proto.ServerError, enum: true)
  field(:message, 5, optional: true, type: :string)
end

defmodule Pulsar.Proto.CommandEndTxnOnPartition do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          request_id: non_neg_integer,
          txnid_least_bits: non_neg_integer,
          txnid_most_bits: non_neg_integer,
          topic: String.t(),
          txn_action: atom | integer
        }
  defstruct [:request_id, :txnid_least_bits, :txnid_most_bits, :topic, :txn_action]

  field(:request_id, 1, required: true, type: :uint64)
  field(:txnid_least_bits, 2, optional: true, type: :uint64, default: 0)
  field(:txnid_most_bits, 3, optional: true, type: :uint64, default: 0)
  field(:topic, 4, optional: true, type: :string)
  field(:txn_action, 5, optional: true, type: Pulsar.Proto.TxnAction, enum: true)
end

defmodule Pulsar.Proto.CommandEndTxnOnPartitionResponse do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          request_id: non_neg_integer,
          txnid_least_bits: non_neg_integer,
          txnid_most_bits: non_neg_integer,
          error: atom | integer,
          message: String.t()
        }
  defstruct [:request_id, :txnid_least_bits, :txnid_most_bits, :error, :message]

  field(:request_id, 1, required: true, type: :uint64)
  field(:txnid_least_bits, 2, optional: true, type: :uint64, default: 0)
  field(:txnid_most_bits, 3, optional: true, type: :uint64, default: 0)
  field(:error, 4, optional: true, type: Pulsar.Proto.ServerError, enum: true)
  field(:message, 5, optional: true, type: :string)
end

defmodule Pulsar.Proto.CommandEndTxnOnSubscription do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          request_id: non_neg_integer,
          txnid_least_bits: non_neg_integer,
          txnid_most_bits: non_neg_integer,
          subscription: Pulsar.Proto.Subscription.t() | nil,
          txn_action: atom | integer
        }
  defstruct [:request_id, :txnid_least_bits, :txnid_most_bits, :subscription, :txn_action]

  field(:request_id, 1, required: true, type: :uint64)
  field(:txnid_least_bits, 2, optional: true, type: :uint64, default: 0)
  field(:txnid_most_bits, 3, optional: true, type: :uint64, default: 0)
  field(:subscription, 4, optional: true, type: Pulsar.Proto.Subscription)
  field(:txn_action, 5, optional: true, type: Pulsar.Proto.TxnAction, enum: true)
end

defmodule Pulsar.Proto.CommandEndTxnOnSubscriptionResponse do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          request_id: non_neg_integer,
          txnid_least_bits: non_neg_integer,
          txnid_most_bits: non_neg_integer,
          error: atom | integer,
          message: String.t()
        }
  defstruct [:request_id, :txnid_least_bits, :txnid_most_bits, :error, :message]

  field(:request_id, 1, required: true, type: :uint64)
  field(:txnid_least_bits, 2, optional: true, type: :uint64, default: 0)
  field(:txnid_most_bits, 3, optional: true, type: :uint64, default: 0)
  field(:error, 4, optional: true, type: Pulsar.Proto.ServerError, enum: true)
  field(:message, 5, optional: true, type: :string)
end

defmodule Pulsar.Proto.BaseCommand do
  @moduledoc false
  use Protobuf, syntax: :proto2

  @type t :: %__MODULE__{
          type: atom | integer,
          connect: Pulsar.Proto.CommandConnect.t() | nil,
          connected: Pulsar.Proto.CommandConnected.t() | nil,
          subscribe: Pulsar.Proto.CommandSubscribe.t() | nil,
          producer: Pulsar.Proto.CommandProducer.t() | nil,
          send: Pulsar.Proto.CommandSend.t() | nil,
          send_receipt: Pulsar.Proto.CommandSendReceipt.t() | nil,
          send_error: Pulsar.Proto.CommandSendError.t() | nil,
          message: Pulsar.Proto.CommandMessage.t() | nil,
          ack: Pulsar.Proto.CommandAck.t() | nil,
          flow: Pulsar.Proto.CommandFlow.t() | nil,
          unsubscribe: Pulsar.Proto.CommandUnsubscribe.t() | nil,
          success: Pulsar.Proto.CommandSuccess.t() | nil,
          error: Pulsar.Proto.CommandError.t() | nil,
          close_producer: Pulsar.Proto.CommandCloseProducer.t() | nil,
          close_consumer: Pulsar.Proto.CommandCloseConsumer.t() | nil,
          producer_success: Pulsar.Proto.CommandProducerSuccess.t() | nil,
          ping: Pulsar.Proto.CommandPing.t() | nil,
          pong: Pulsar.Proto.CommandPong.t() | nil,
          redeliverUnacknowledgedMessages:
            Pulsar.Proto.CommandRedeliverUnacknowledgedMessages.t() | nil,
          partitionMetadata: Pulsar.Proto.CommandPartitionedTopicMetadata.t() | nil,
          partitionMetadataResponse:
            Pulsar.Proto.CommandPartitionedTopicMetadataResponse.t() | nil,
          lookupTopic: Pulsar.Proto.CommandLookupTopic.t() | nil,
          lookupTopicResponse: Pulsar.Proto.CommandLookupTopicResponse.t() | nil,
          consumerStats: Pulsar.Proto.CommandConsumerStats.t() | nil,
          consumerStatsResponse: Pulsar.Proto.CommandConsumerStatsResponse.t() | nil,
          reachedEndOfTopic: Pulsar.Proto.CommandReachedEndOfTopic.t() | nil,
          seek: Pulsar.Proto.CommandSeek.t() | nil,
          getLastMessageId: Pulsar.Proto.CommandGetLastMessageId.t() | nil,
          getLastMessageIdResponse: Pulsar.Proto.CommandGetLastMessageIdResponse.t() | nil,
          active_consumer_change: Pulsar.Proto.CommandActiveConsumerChange.t() | nil,
          getTopicsOfNamespace: Pulsar.Proto.CommandGetTopicsOfNamespace.t() | nil,
          getTopicsOfNamespaceResponse:
            Pulsar.Proto.CommandGetTopicsOfNamespaceResponse.t() | nil,
          getSchema: Pulsar.Proto.CommandGetSchema.t() | nil,
          getSchemaResponse: Pulsar.Proto.CommandGetSchemaResponse.t() | nil,
          authChallenge: Pulsar.Proto.CommandAuthChallenge.t() | nil,
          authResponse: Pulsar.Proto.CommandAuthResponse.t() | nil,
          ackResponse: Pulsar.Proto.CommandAckResponse.t() | nil,
          getOrCreateSchema: Pulsar.Proto.CommandGetOrCreateSchema.t() | nil,
          getOrCreateSchemaResponse: Pulsar.Proto.CommandGetOrCreateSchemaResponse.t() | nil,
          newTxn: Pulsar.Proto.CommandNewTxn.t() | nil,
          newTxnResponse: Pulsar.Proto.CommandNewTxnResponse.t() | nil,
          addPartitionToTxn: Pulsar.Proto.CommandAddPartitionToTxn.t() | nil,
          addPartitionToTxnResponse: Pulsar.Proto.CommandAddPartitionToTxnResponse.t() | nil,
          addSubscriptionToTxn: Pulsar.Proto.CommandAddSubscriptionToTxn.t() | nil,
          addSubscriptionToTxnResponse:
            Pulsar.Proto.CommandAddSubscriptionToTxnResponse.t() | nil,
          endTxn: Pulsar.Proto.CommandEndTxn.t() | nil,
          endTxnResponse: Pulsar.Proto.CommandEndTxnResponse.t() | nil,
          endTxnOnPartition: Pulsar.Proto.CommandEndTxnOnPartition.t() | nil,
          endTxnOnPartitionResponse: Pulsar.Proto.CommandEndTxnOnPartitionResponse.t() | nil,
          endTxnOnSubscription: Pulsar.Proto.CommandEndTxnOnSubscription.t() | nil,
          endTxnOnSubscriptionResponse: Pulsar.Proto.CommandEndTxnOnSubscriptionResponse.t() | nil
        }
  defstruct [
    :type,
    :connect,
    :connected,
    :subscribe,
    :producer,
    :send,
    :send_receipt,
    :send_error,
    :message,
    :ack,
    :flow,
    :unsubscribe,
    :success,
    :error,
    :close_producer,
    :close_consumer,
    :producer_success,
    :ping,
    :pong,
    :redeliverUnacknowledgedMessages,
    :partitionMetadata,
    :partitionMetadataResponse,
    :lookupTopic,
    :lookupTopicResponse,
    :consumerStats,
    :consumerStatsResponse,
    :reachedEndOfTopic,
    :seek,
    :getLastMessageId,
    :getLastMessageIdResponse,
    :active_consumer_change,
    :getTopicsOfNamespace,
    :getTopicsOfNamespaceResponse,
    :getSchema,
    :getSchemaResponse,
    :authChallenge,
    :authResponse,
    :ackResponse,
    :getOrCreateSchema,
    :getOrCreateSchemaResponse,
    :newTxn,
    :newTxnResponse,
    :addPartitionToTxn,
    :addPartitionToTxnResponse,
    :addSubscriptionToTxn,
    :addSubscriptionToTxnResponse,
    :endTxn,
    :endTxnResponse,
    :endTxnOnPartition,
    :endTxnOnPartitionResponse,
    :endTxnOnSubscription,
    :endTxnOnSubscriptionResponse
  ]

  field(:type, 1, required: true, type: Pulsar.Proto.BaseCommand.Type, enum: true)
  field(:connect, 2, optional: true, type: Pulsar.Proto.CommandConnect)
  field(:connected, 3, optional: true, type: Pulsar.Proto.CommandConnected)
  field(:subscribe, 4, optional: true, type: Pulsar.Proto.CommandSubscribe)
  field(:producer, 5, optional: true, type: Pulsar.Proto.CommandProducer)
  field(:send, 6, optional: true, type: Pulsar.Proto.CommandSend)
  field(:send_receipt, 7, optional: true, type: Pulsar.Proto.CommandSendReceipt)
  field(:send_error, 8, optional: true, type: Pulsar.Proto.CommandSendError)
  field(:message, 9, optional: true, type: Pulsar.Proto.CommandMessage)
  field(:ack, 10, optional: true, type: Pulsar.Proto.CommandAck)
  field(:flow, 11, optional: true, type: Pulsar.Proto.CommandFlow)
  field(:unsubscribe, 12, optional: true, type: Pulsar.Proto.CommandUnsubscribe)
  field(:success, 13, optional: true, type: Pulsar.Proto.CommandSuccess)
  field(:error, 14, optional: true, type: Pulsar.Proto.CommandError)
  field(:close_producer, 15, optional: true, type: Pulsar.Proto.CommandCloseProducer)
  field(:close_consumer, 16, optional: true, type: Pulsar.Proto.CommandCloseConsumer)
  field(:producer_success, 17, optional: true, type: Pulsar.Proto.CommandProducerSuccess)
  field(:ping, 18, optional: true, type: Pulsar.Proto.CommandPing)
  field(:pong, 19, optional: true, type: Pulsar.Proto.CommandPong)

  field(:redeliverUnacknowledgedMessages, 20,
    optional: true,
    type: Pulsar.Proto.CommandRedeliverUnacknowledgedMessages
  )

  field(:partitionMetadata, 21, optional: true, type: Pulsar.Proto.CommandPartitionedTopicMetadata)

  field(:partitionMetadataResponse, 22,
    optional: true,
    type: Pulsar.Proto.CommandPartitionedTopicMetadataResponse
  )

  field(:lookupTopic, 23, optional: true, type: Pulsar.Proto.CommandLookupTopic)
  field(:lookupTopicResponse, 24, optional: true, type: Pulsar.Proto.CommandLookupTopicResponse)
  field(:consumerStats, 25, optional: true, type: Pulsar.Proto.CommandConsumerStats)

  field(:consumerStatsResponse, 26,
    optional: true,
    type: Pulsar.Proto.CommandConsumerStatsResponse
  )

  field(:reachedEndOfTopic, 27, optional: true, type: Pulsar.Proto.CommandReachedEndOfTopic)
  field(:seek, 28, optional: true, type: Pulsar.Proto.CommandSeek)
  field(:getLastMessageId, 29, optional: true, type: Pulsar.Proto.CommandGetLastMessageId)

  field(:getLastMessageIdResponse, 30,
    optional: true,
    type: Pulsar.Proto.CommandGetLastMessageIdResponse
  )

  field(:active_consumer_change, 31,
    optional: true,
    type: Pulsar.Proto.CommandActiveConsumerChange
  )

  field(:getTopicsOfNamespace, 32, optional: true, type: Pulsar.Proto.CommandGetTopicsOfNamespace)

  field(:getTopicsOfNamespaceResponse, 33,
    optional: true,
    type: Pulsar.Proto.CommandGetTopicsOfNamespaceResponse
  )

  field(:getSchema, 34, optional: true, type: Pulsar.Proto.CommandGetSchema)
  field(:getSchemaResponse, 35, optional: true, type: Pulsar.Proto.CommandGetSchemaResponse)
  field(:authChallenge, 36, optional: true, type: Pulsar.Proto.CommandAuthChallenge)
  field(:authResponse, 37, optional: true, type: Pulsar.Proto.CommandAuthResponse)
  field(:ackResponse, 38, optional: true, type: Pulsar.Proto.CommandAckResponse)
  field(:getOrCreateSchema, 39, optional: true, type: Pulsar.Proto.CommandGetOrCreateSchema)

  field(:getOrCreateSchemaResponse, 40,
    optional: true,
    type: Pulsar.Proto.CommandGetOrCreateSchemaResponse
  )

  field(:newTxn, 50, optional: true, type: Pulsar.Proto.CommandNewTxn)
  field(:newTxnResponse, 51, optional: true, type: Pulsar.Proto.CommandNewTxnResponse)
  field(:addPartitionToTxn, 52, optional: true, type: Pulsar.Proto.CommandAddPartitionToTxn)

  field(:addPartitionToTxnResponse, 53,
    optional: true,
    type: Pulsar.Proto.CommandAddPartitionToTxnResponse
  )

  field(:addSubscriptionToTxn, 54, optional: true, type: Pulsar.Proto.CommandAddSubscriptionToTxn)

  field(:addSubscriptionToTxnResponse, 55,
    optional: true,
    type: Pulsar.Proto.CommandAddSubscriptionToTxnResponse
  )

  field(:endTxn, 56, optional: true, type: Pulsar.Proto.CommandEndTxn)
  field(:endTxnResponse, 57, optional: true, type: Pulsar.Proto.CommandEndTxnResponse)
  field(:endTxnOnPartition, 58, optional: true, type: Pulsar.Proto.CommandEndTxnOnPartition)

  field(:endTxnOnPartitionResponse, 59,
    optional: true,
    type: Pulsar.Proto.CommandEndTxnOnPartitionResponse
  )

  field(:endTxnOnSubscription, 60, optional: true, type: Pulsar.Proto.CommandEndTxnOnSubscription)

  field(:endTxnOnSubscriptionResponse, 61,
    optional: true,
    type: Pulsar.Proto.CommandEndTxnOnSubscriptionResponse
  )
end

defmodule Pulsar.Proto.BaseCommand.Type do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto2

  field(:CONNECT, 2)
  field(:CONNECTED, 3)
  field(:SUBSCRIBE, 4)
  field(:PRODUCER, 5)
  field(:SEND, 6)
  field(:SEND_RECEIPT, 7)
  field(:SEND_ERROR, 8)
  field(:MESSAGE, 9)
  field(:ACK, 10)
  field(:FLOW, 11)
  field(:UNSUBSCRIBE, 12)
  field(:SUCCESS, 13)
  field(:ERROR, 14)
  field(:CLOSE_PRODUCER, 15)
  field(:CLOSE_CONSUMER, 16)
  field(:PRODUCER_SUCCESS, 17)
  field(:PING, 18)
  field(:PONG, 19)
  field(:REDELIVER_UNACKNOWLEDGED_MESSAGES, 20)
  field(:PARTITIONED_METADATA, 21)
  field(:PARTITIONED_METADATA_RESPONSE, 22)
  field(:LOOKUP, 23)
  field(:LOOKUP_RESPONSE, 24)
  field(:CONSUMER_STATS, 25)
  field(:CONSUMER_STATS_RESPONSE, 26)
  field(:REACHED_END_OF_TOPIC, 27)
  field(:SEEK, 28)
  field(:GET_LAST_MESSAGE_ID, 29)
  field(:GET_LAST_MESSAGE_ID_RESPONSE, 30)
  field(:ACTIVE_CONSUMER_CHANGE, 31)
  field(:GET_TOPICS_OF_NAMESPACE, 32)
  field(:GET_TOPICS_OF_NAMESPACE_RESPONSE, 33)
  field(:GET_SCHEMA, 34)
  field(:GET_SCHEMA_RESPONSE, 35)
  field(:AUTH_CHALLENGE, 36)
  field(:AUTH_RESPONSE, 37)
  field(:ACK_RESPONSE, 38)
  field(:GET_OR_CREATE_SCHEMA, 39)
  field(:GET_OR_CREATE_SCHEMA_RESPONSE, 40)
  field(:NEW_TXN, 50)
  field(:NEW_TXN_RESPONSE, 51)
  field(:ADD_PARTITION_TO_TXN, 52)
  field(:ADD_PARTITION_TO_TXN_RESPONSE, 53)
  field(:ADD_SUBSCRIPTION_TO_TXN, 54)
  field(:ADD_SUBSCRIPTION_TO_TXN_RESPONSE, 55)
  field(:END_TXN, 56)
  field(:END_TXN_RESPONSE, 57)
  field(:END_TXN_ON_PARTITION, 58)
  field(:END_TXN_ON_PARTITION_RESPONSE, 59)
  field(:END_TXN_ON_SUBSCRIPTION, 60)
  field(:END_TXN_ON_SUBSCRIPTION_RESPONSE, 61)
end

defmodule Pulsar.Proto.CompressionType do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto2

  field(:NONE, 0)
  field(:LZ4, 1)
  field(:ZLIB, 2)
  field(:ZSTD, 3)
  field(:SNAPPY, 4)
end

defmodule Pulsar.Proto.ServerError do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto2

  field(:UnknownError, 0)
  field(:MetadataError, 1)
  field(:PersistenceError, 2)
  field(:AuthenticationError, 3)
  field(:AuthorizationError, 4)
  field(:ConsumerBusy, 5)
  field(:ServiceNotReady, 6)
  field(:ProducerBlockedQuotaExceededError, 7)
  field(:ProducerBlockedQuotaExceededException, 8)
  field(:ChecksumError, 9)
  field(:UnsupportedVersionError, 10)
  field(:TopicNotFound, 11)
  field(:SubscriptionNotFound, 12)
  field(:ConsumerNotFound, 13)
  field(:TooManyRequests, 14)
  field(:TopicTerminatedError, 15)
  field(:ProducerBusy, 16)
  field(:InvalidTopicName, 17)
  field(:IncompatibleSchema, 18)
  field(:ConsumerAssignError, 19)
end

defmodule Pulsar.Proto.AuthMethod do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto2

  field(:AuthMethodNone, 0)
  field(:AuthMethodYcaV1, 1)
  field(:AuthMethodAthens, 2)
end

defmodule Pulsar.Proto.ProtocolVersion do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto2

  field(:v0, 0)
  field(:v1, 1)
  field(:v2, 2)
  field(:v3, 3)
  field(:v4, 4)
  field(:v5, 5)
  field(:v6, 6)
  field(:v7, 7)
  field(:v8, 8)
  field(:v9, 9)
  field(:v10, 10)
  field(:v11, 11)
  field(:v12, 12)
  field(:v13, 13)
  field(:v14, 14)
  field(:v15, 15)
end

defmodule Pulsar.Proto.KeySharedMode do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto2

  field(:AUTO_SPLIT, 0)
  field(:STICKY, 1)
end

defmodule Pulsar.Proto.TxnAction do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto2

  field(:COMMIT, 0)
  field(:ABORT, 1)
end
