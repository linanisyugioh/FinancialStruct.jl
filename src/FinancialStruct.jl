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
c"#include <om_data_types.h>"
c"#include <ThostFtdcUserApiDataType.h>"
c"#include <ThostFtdcUserApiStruct.h>"

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
cCombActionReq= bitstype(c"CombActionReq")
cCombAction   = bitstype(c"CombAction")
cPosition     = bitstype(c"Position")
cCash         = bitstype(c"Cash")
cIndicator    = bitstype(c"Indicator")

#期货实盘相关
cFuOrder      = bitstype(c"FuOrder")
cFuOrderReq   = bitstype(c"FuOrderReq")
cFuTrade      = bitstype(c"FuTrade")
cFuPosition   = bitstype(c"FuPosition")
cFuCodeInfo   = bitstype(c"FuCodeInfo")

#订单管理相关
cOmTrade                   = bitstype(c"OmTrade")
cOmOrder                   = bitstype(c"OmOrder")
cContractStat              = bitstype(c"ContractStat")
cPositionUnit              = bitstype(c"PositionUnit")
cPositionCloseParam        = bitstype(c"PositionCloseParam")
cPositionUnitHis           = bitstype(c"PositionUnitHis")
cPositionWithOrder         = bitstype(c"PositionWithOrder")
cAccountPositionWithOrder  = bitstype(c"AccountPositionWithOrder")
cFeeCodeInfo               = bitstype(c"FeeCodeInfo")
cFundtable                 = bitstype(c"Fundtable")
cFundtableHis              = bitstype(c"FundtableHis")
cAccountFundtable          = bitstype(c"AccountFundtable")
cAccountFundtableHis       = bitstype(c"AccountFundtableHis")
cAccountPositionUnit       = bitstype(c"AccountPositionUnit")
cAccountPositionCloseParam = bitstype(c"AccountPositionCloseParam")
cAccountPositionUnitHis    = bitstype(c"AccountPositionUnitHis")
cCombinationUnit           = bitstype(c"CombinationUnit")
cCombinationUnitHis        = bitstype(c"CombinationUnitHis")
cAccountContractStat       = bitstype(c"AccountContractStat")
cAccountScopePnlDelta      = bitstype(c"AccountScopePnlDelta")
cExternalPosition          = bitstype(c"ExternalPosition")


#上期 CTP 接口结构体（ThostFtdcUserApiStruct.h）
#命名约定：cCtp + 去掉 "CThostFtdc" 前缀与 "Field" 后缀
#         CThostFtdcReqUserLoginField -> cCtpReqUserLogin
#         CTP struct 共 386 个，下面只列出量化最常用的核心子集，
#         其余按需自行 cCtpXxx = bitstype(c"struct CThostFtdcXxxField") 添加
cCtpRspInfo                       = bitstype(c"struct CThostFtdcRspInfoField")
cCtpReqUserLogin                  = bitstype(c"struct CThostFtdcReqUserLoginField")
cCtpRspUserLogin                  = bitstype(c"struct CThostFtdcRspUserLoginField")
cCtpUserLogout                    = bitstype(c"struct CThostFtdcUserLogoutField")
cCtpReqAuthenticate               = bitstype(c"struct CThostFtdcReqAuthenticateField")
cCtpRspAuthenticate               = bitstype(c"struct CThostFtdcRspAuthenticateField")
cCtpUserPasswordUpdate            = bitstype(c"struct CThostFtdcUserPasswordUpdateField")
cCtpSettlementInfo                = bitstype(c"struct CThostFtdcSettlementInfoField")
cCtpSettlementInfoConfirm         = bitstype(c"struct CThostFtdcSettlementInfoConfirmField")
cCtpInputOrder                    = bitstype(c"struct CThostFtdcInputOrderField")
cCtpInputOrderAction              = bitstype(c"struct CThostFtdcInputOrderActionField")
cCtpOrder                         = bitstype(c"struct CThostFtdcOrderField")
cCtpOrderAction                   = bitstype(c"struct CThostFtdcOrderActionField")
cCtpTrade                         = bitstype(c"struct CThostFtdcTradeField")
cCtpInvestor                      = bitstype(c"struct CThostFtdcInvestorField")
cCtpInvestorPosition              = bitstype(c"struct CThostFtdcInvestorPositionField")
cCtpInvestorPositionDetail        = bitstype(c"struct CThostFtdcInvestorPositionDetailField")
cCtpInvestorPositionCombineDetail = bitstype(c"struct CThostFtdcInvestorPositionCombineDetailField")
cCtpTradingAccount                = bitstype(c"struct CThostFtdcTradingAccountField")
cCtpInstrument                    = bitstype(c"struct CThostFtdcInstrumentField")
cCtpDepthMarketData               = bitstype(c"struct CThostFtdcDepthMarketDataField")
cCtpSpecificInstrument            = bitstype(c"struct CThostFtdcSpecificInstrumentField")
#常用 Qry 请求
cCtpQryOrder                      = bitstype(c"struct CThostFtdcQryOrderField")
cCtpQryTrade                      = bitstype(c"struct CThostFtdcQryTradeField")
cCtpQryInvestorPosition           = bitstype(c"struct CThostFtdcQryInvestorPositionField")
cCtpQryInvestorPositionDetail     = bitstype(c"struct CThostFtdcQryInvestorPositionDetailField")
cCtpQryTradingAccount             = bitstype(c"struct CThostFtdcQryTradingAccountField")
cCtpQryInvestor                   = bitstype(c"struct CThostFtdcQryInvestorField")
cCtpQryInstrument                 = bitstype(c"struct CThostFtdcQryInstrumentField")
cCtpQryDepthMarketData            = bitstype(c"struct CThostFtdcQryDepthMarketDataField")
cCtpQrySettlementInfo             = bitstype(c"struct CThostFtdcQrySettlementInfoField")
cCtpQryInstrumentMarginRate       = bitstype(c"struct CThostFtdcQryInstrumentMarginRateField")
cCtpQryInstrumentCommissionRate   = bitstype(c"struct CThostFtdcQryInstrumentCommissionRateField")


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

#/*
# * 数据字段类型定义。
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
#*/
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
