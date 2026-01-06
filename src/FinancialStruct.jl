module FinancialStruct
using CBinding
const MODULE_ROOT = @__DIR__

const c"int8_t"  = Int8
const c"int16_t" = Int16
const c"int32_t" = Int32
const c"int64_t" = Int64
const c"uint8_t"  = UInt8
const c"uint16_t" = UInt16
const c"uint32_t" = UInt32
const c"uint64_t" = UInt64
c``
const INC_DIR = joinpath(@__DIR__, "..", "deps", "include")
const LIB_DIR = joinpath(@__DIR__, "..", "deps", "lib")  # 如果需要链接库
#const INC_DIR = joinpath(@__DIR__, "deps", "include")
#const LIB_DIR = joinpath(@__DIR__, "deps", "lib")  # 如果需要链接库
c`-std=c99 -fparse-all-comments -I$(INC_DIR) -L$(LIB_DIR)`
c"#include <stdint.h>"
c"#include <md_def.h>"
c"#include <stdbool.h>"
c"#include <tb_lib_def.h>"
c"#include <trade_def.h>"
cSecurityTickData  = bitstype(c"SecurityTickData")
cIndexTickData     = bitstype(c"IndexTickData")
cFuturesTickData   = bitstype(c"FuturesTickData") 
cOptionsTickData   = bitstype(c"OptionsTickData")
cSecurityKdata     = bitstype(c"SecurityKdata")
cCodeInfo          = bitstype(c"CodeInfo")
cTradeDate         = bitstype(c"TradeDate")
cQxData            = bitstype(c"QxData")
cOrderQueueItemData= bitstype(c"OrderQueueItemData")
cOrderQueueData    = bitstype(c"OrderQueueData")
cTickByTickEntrust = bitstype(c"TickByTickEntrust")
cTickByTickTrade   = bitstype(c"TickByTickTrade")
cTickByTickData    = bitstype(c"TickByTickData")
cDateUpdateData    = bitstype(c"DateUpdateData") 
cOnlyTBTickData    = bitstype(c"OnlyTBTickData")
cOrderReq     = bitstype(c"OrderReq")
cCancelReq    = bitstype(c"CancelReq") 
cCancelDetail = bitstype(c"CancelDetail")
cOrderRsp     = bitstype(c"OrderRsp")
cOrder        = bitstype(c"Order")
cTrade        = bitstype(c"Trade")
cPosition     = bitstype(c"Position")
cCash         = bitstype(c"Cash")
cIndicator    = bitstype(c"Indicator")

#期货实盘相关
cFuOrder      = bitstype(c"FuOrder")
cFuOrderReq   = bitstype(c"FuOrderReq")
cFuTrade      = bitstype(c"FuTrade")
cFuPosition   = bitstype(c"FuPosition")

@enum HRetCode HRetCode_OK = 0 HRetCode_NotFound = -1 HRetCode_Corruption = -2 HRetCode_NotSupported = -3 HRetCode_InvalidArgument = -4 HRetCode_IOError = -5 HRetCode_Incomplete = -6 HRetCode_Full = -8 HRetCode_NotEnoughMemory = -9 HRetCode_EOF = -10 HRetCode_InvalidTime = -11 HRetCode_NetTimeout = -12 HRetCode_ConnError = -13 HRetCode_AuthError = -14 HRetCode_NetIOError = -15 HRetCode_ExceedLimit = -16
@enum HFileAccFlag HFileAcc_ReadOnly = 0 HFileAcc_ReadWrite HFileAcc_GenerateIndexFile
@enum HFieldType HFieldType_Char = 0 HFieldType_Short HFieldType_UShort HFieldType_Int HFieldType_UInt HFieldType_Long HFieldType_ULong HFieldType_Float HFieldType_Double HFieldType_CharArray HFieldType_ZeroTermCharArray HFieldType_SpaceTermCharArray HFieldType_IntArray HFieldType_ZeroTermIntArray HFieldType_UIntArray HFieldType_ZeroTermUIntArray HFieldType_LongArray HFieldType_ZeroTermLongArray HFieldType_ULongArray HFieldType_ZeroTermULongArray
@enum HFieldEncodeOp HFieldEncodeOp_Raw = 0 HFieldEncodeOp_ValueCompress HFieldEncodeOp_ValueIncCompress
@enum HFieldFlag HFieldFlag_Optional = 1
@enum HClientCreateFileOption HClientCF_FailOnExist = 0 HClientCF_ClearCurrData HClientCF_AppendData

for file in ["bar.jl", "baseinfo.jl", "fundmentals.jl", "hkdata.jl", "marketdata.jl", "staticinfo.jl"]
    file_path = joinpath(MODULE_ROOT, "struct", file)
    if isfile(file_path)
        include(file_path)
        println("HDB $file included successfully.")
    else
        @warn "HDB struct file $file not found at $file_path"
    end
end

#/**
# * 数据字段类型定义。
# */
#enum HFieldType {
#  HFieldType_Char = 0,                /// 字符类型，长度1字节
#  HFieldType_Short,                   /// 短整型，长度2字节
#  HFieldType_UShort,                  /// 无符号短整型，长度2字节
#  HFieldType_Int,                     /// 整型，长度4字节
#  HFieldType_UInt,                    /// 无符号整型，长度4字节
#  HFieldType_Long,                    /// 长整型，长度8字节
#  HFieldType_ULong,                   /// 无符号长整型，长度8字节
#  HFieldType_Float,                   /// 单精度浮点数，长度4字节
#  HFieldType_Double,                  /// 双精度浮点数，长度8字节
#  HFieldType_CharArray,               /// 字符数组
#  HFieldType_ZeroTermCharArray,       /// 以0结尾的字符数组
#  HFieldType_SpaceTermCharArray,      /// 以空格结尾的字符数组
#  HFieldType_IntArray,                /// 整数数组
#  HFieldType_ZeroTermIntArray,        /// 以0结尾的整数数组
#  HFieldType_UIntArray,               /// 无符号整数数组
#  HFieldType_ZeroTermUIntArray,       /// 以0结尾的无符号整数数组
#  HFieldType_LongArray,               /// 长整数数组
#  HFieldType_ZeroTermLongArray,       /// 以0结尾的长整数数组
#  HFieldType_ULongArray,              /// 无符号长整数数组
#  HFieldType_ZeroTermULongArray,      /// 以0结尾的无符号长整数数组
#};
#type_tuple与ctype_tuple均与HFieldType中的类型一一对应
const type_tuple = (Cchar, Int16, UInt16, Int32, UInt32, Int64, UInt64, Float32, Float64, 
Cchar, Cchar, Cchar, Int32, Int32, UInt32, UInt32, Int64, Int64, UInt64, UInt64)

const ctype_tuple = ("char", "int16_t", "uint16_t", "int32_t", "uint32_t", "int64_t", "uint64_t", "float", "double",
 "char", "char", "char", "int32_t", "int32_t", "uint32_t", "uint32_t", "int64_t", "int64_t", "uint64_t", "uint64_t")

const HDB_MAX_FILE_TYPE_NUM = 64
const HDB_MAX_DATA_FIELD_NUM = 512
const HDB_MAX_DATA_OPT_FIELD_NUM = 63
const HDB_MAX_SYMBOL_SIZE = 24
const HDB_MAX_TYPENANE_SIZE = 32
const HDB_MAX_FIELDNANE_SIZE = 32
const HDB_MAX_ITEMDATA_SIZE = 64 * 1024
const HDB_MAX_CLIENT_FILE_READ_SIZE = 250 * 1024
 
struct HDataField
  field_name::NTuple{HDB_MAX_FIELDNANE_SIZE, Cchar}
  field_type::Cint
  field_op::Cint
  field_size::Cint
  field_flags::Cint
end

struct HDataType
  type::NTuple{HDB_MAX_TYPENANE_SIZE, Cchar}
  field_count::Cint
  fields::NTuple{HDB_MAX_DATA_FIELD_NUM, HDataField}
  data_size::Cint
end

struct HDataItem
  symbol::NTuple{HDB_MAX_SYMBOL_SIZE, Cchar}
  index::Cint
  trading_day::Cint
  local_time::Int64
  time_point_seq_no::Cint
  type_id::Cint           
  data::Ptr{UInt8}
end

struct HCodeInfo
  symbol::NTuple{HDB_MAX_SYMBOL_SIZE,Cchar}
  index::Cint
  total_items_num::Cint
  type_items_nums::NTuple{HDB_MAX_FILE_TYPE_NUM,Cint}
  data::Ptr{UInt8}
end

end
