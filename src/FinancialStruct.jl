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

const cSecurityTickData  = bitstype(c"SecurityTickData")
const cIndexTickData     = bitstype(c"IndexTickData")
const cFuturesTickData   = bitstype(c"FuturesTickData") 
const cOptionsTickData   = bitstype(c"OptionsTickData")
const cSecurityKdata     = bitstype(c"SecurityKdata")
const cCodeInfo          = bitstype(c"CodeInfo")
const cTradeDate         = bitstype(c"TradeDate")
const cQxData            = bitstype(c"QxData")
const cOrderQueueItemData = bitstype(c"OrderQueueItemData")
const cOrderQueueData    = bitstype(c"OrderQueueData")
const cTickByTickEntrust = bitstype(c"TickByTickEntrust")
const cTickByTickTrade   = bitstype(c"TickByTickTrade")
const cTickByTickData    = bitstype(c"TickByTickData")
const cDateUpdateData    = bitstype(c"DateUpdateData") 
const cOnlyTBTickData    = bitstype(c"OnlyTBTickData")
const cOrderReq     = bitstype(c"OrderReq")
const cCancelReq    = bitstype(c"CancelReq") 
const cCancelDetail = bitstype(c"CancelDetail")
const cOrderRsp     = bitstype(c"OrderRsp")
const cOrder        = bitstype(c"Order")
const cTrade        = bitstype(c"Trade")
const cCombActionReq = bitstype(c"CombActionReq")
const cCombAction   = bitstype(c"CombAction")
const cPosition     = bitstype(c"Position")
const cCash         = bitstype(c"Cash")
const cIndicator    = bitstype(c"Indicator")

#期货实盘相关
const cFuOrder      = bitstype(c"FuOrder")
const cFuOrderReq   = bitstype(c"FuOrderReq")
const cFuTrade      = bitstype(c"FuTrade")
const cFuPosition   = bitstype(c"FuPosition")
const cFuCodeInfo   = bitstype(c"FuCodeInfo")

#订单管理相关
const cOmTrade                   = bitstype(c"OmTrade")
const cOmOrder                   = bitstype(c"OmOrder")
const cContractStat              = bitstype(c"ContractStat")
const cPositionUnit              = bitstype(c"PositionUnit")
const cPositionCloseParam        = bitstype(c"PositionCloseParam")
const cPositionUnitHis           = bitstype(c"PositionUnitHis")
const cPositionWithOrder         = bitstype(c"PositionWithOrder")
const cAccountPositionWithOrder  = bitstype(c"AccountPositionWithOrder")
const cFeeCodeInfo               = bitstype(c"FeeCodeInfo")
const cFundtable                 = bitstype(c"Fundtable")
const cFundtableHis              = bitstype(c"FundtableHis")
const cAccountFundtable          = bitstype(c"AccountFundtable")
const cAccountFundtableHis       = bitstype(c"AccountFundtableHis")
const cAccountPositionUnit       = bitstype(c"AccountPositionUnit")
const cAccountPositionCloseParam = bitstype(c"AccountPositionCloseParam")
const cAccountPositionUnitHis    = bitstype(c"AccountPositionUnitHis")
const cCombinationUnit           = bitstype(c"CombinationUnit")
const cCombinationUnitHis        = bitstype(c"CombinationUnitHis")
const cAccountContractStat       = bitstype(c"AccountContractStat")
const cAccountScopePnlDelta      = bitstype(c"AccountScopePnlDelta")
const cExternalPosition          = bitstype(c"ExternalPosition")


#上期 CTP 接口结构体（ThostFtdcUserApiStruct.h）
#命名约定：cCtp + 去掉 "CThostFtdc" 前缀与 "Field" 后缀
#         CThostFtdcReqUserLoginField -> cCtpReqUserLogin
#         共 386 个，全部自动生成于此（与上游头文件 1:1 对齐）
const cCtpDissemination                    = bitstype(c"struct CThostFtdcDisseminationField")
const cCtpReqUserLogin                     = bitstype(c"struct CThostFtdcReqUserLoginField")
const cCtpRspUserLogin                     = bitstype(c"struct CThostFtdcRspUserLoginField")
const cCtpUserLogout                       = bitstype(c"struct CThostFtdcUserLogoutField")
const cCtpForceUserLogout                  = bitstype(c"struct CThostFtdcForceUserLogoutField")
const cCtpReqAuthenticate                  = bitstype(c"struct CThostFtdcReqAuthenticateField")
const cCtpRspAuthenticate                  = bitstype(c"struct CThostFtdcRspAuthenticateField")
const cCtpAuthenticationInfo               = bitstype(c"struct CThostFtdcAuthenticationInfoField")
const cCtpRspUserLogin2                    = bitstype(c"struct CThostFtdcRspUserLogin2Field")
const cCtpTransferHeader                   = bitstype(c"struct CThostFtdcTransferHeaderField")
const cCtpTransferBankToFutureReq          = bitstype(c"struct CThostFtdcTransferBankToFutureReqField")
const cCtpTransferBankToFutureRsp          = bitstype(c"struct CThostFtdcTransferBankToFutureRspField")
const cCtpTransferFutureToBankReq          = bitstype(c"struct CThostFtdcTransferFutureToBankReqField")
const cCtpTransferFutureToBankRsp          = bitstype(c"struct CThostFtdcTransferFutureToBankRspField")
const cCtpTransferQryBankReq               = bitstype(c"struct CThostFtdcTransferQryBankReqField")
const cCtpTransferQryBankRsp               = bitstype(c"struct CThostFtdcTransferQryBankRspField")
const cCtpTransferQryDetailReq             = bitstype(c"struct CThostFtdcTransferQryDetailReqField")
const cCtpTransferQryDetailRsp             = bitstype(c"struct CThostFtdcTransferQryDetailRspField")
const cCtpRspInfo                          = bitstype(c"struct CThostFtdcRspInfoField")
const cCtpExchange                         = bitstype(c"struct CThostFtdcExchangeField")
const cCtpProduct                          = bitstype(c"struct CThostFtdcProductField")
const cCtpInstrument                       = bitstype(c"struct CThostFtdcInstrumentField")
const cCtpBroker                           = bitstype(c"struct CThostFtdcBrokerField")
const cCtpTrader                           = bitstype(c"struct CThostFtdcTraderField")
const cCtpInvestor                         = bitstype(c"struct CThostFtdcInvestorField")
const cCtpTradingCode                      = bitstype(c"struct CThostFtdcTradingCodeField")
const cCtpPartBroker                       = bitstype(c"struct CThostFtdcPartBrokerField")
const cCtpSuperUser                        = bitstype(c"struct CThostFtdcSuperUserField")
const cCtpSuperUserFunction                = bitstype(c"struct CThostFtdcSuperUserFunctionField")
const cCtpInvestorGroup                    = bitstype(c"struct CThostFtdcInvestorGroupField")
const cCtpTradingAccount                   = bitstype(c"struct CThostFtdcTradingAccountField")
const cCtpInvestorPosition                 = bitstype(c"struct CThostFtdcInvestorPositionField")
const cCtpInstrumentMarginRate             = bitstype(c"struct CThostFtdcInstrumentMarginRateField")
const cCtpInstrumentCommissionRate         = bitstype(c"struct CThostFtdcInstrumentCommissionRateField")
const cCtpDepthMarketData                  = bitstype(c"struct CThostFtdcDepthMarketDataField")
const cCtpInstrumentTradingRight           = bitstype(c"struct CThostFtdcInstrumentTradingRightField")
const cCtpBrokerUser                       = bitstype(c"struct CThostFtdcBrokerUserField")
const cCtpBrokerUserPassword               = bitstype(c"struct CThostFtdcBrokerUserPasswordField")
const cCtpBrokerUserFunction               = bitstype(c"struct CThostFtdcBrokerUserFunctionField")
const cCtpTraderOffer                      = bitstype(c"struct CThostFtdcTraderOfferField")
const cCtpSettlementInfo                   = bitstype(c"struct CThostFtdcSettlementInfoField")
const cCtpInstrumentMarginRateAdjust       = bitstype(c"struct CThostFtdcInstrumentMarginRateAdjustField")
const cCtpExchangeMarginRate               = bitstype(c"struct CThostFtdcExchangeMarginRateField")
const cCtpExchangeMarginRateAdjust         = bitstype(c"struct CThostFtdcExchangeMarginRateAdjustField")
const cCtpExchangeRate                     = bitstype(c"struct CThostFtdcExchangeRateField")
const cCtpSettlementRef                    = bitstype(c"struct CThostFtdcSettlementRefField")
const cCtpCurrentTime                      = bitstype(c"struct CThostFtdcCurrentTimeField")
const cCtpCommPhase                        = bitstype(c"struct CThostFtdcCommPhaseField")
const cCtpLoginInfo                        = bitstype(c"struct CThostFtdcLoginInfoField")
const cCtpLogoutAll                        = bitstype(c"struct CThostFtdcLogoutAllField")
const cCtpFrontStatus                      = bitstype(c"struct CThostFtdcFrontStatusField")
const cCtpUserPasswordUpdate               = bitstype(c"struct CThostFtdcUserPasswordUpdateField")
const cCtpInputOrder                       = bitstype(c"struct CThostFtdcInputOrderField")
const cCtpOrder                            = bitstype(c"struct CThostFtdcOrderField")
const cCtpExchangeOrder                    = bitstype(c"struct CThostFtdcExchangeOrderField")
const cCtpExchangeOrderInsertError         = bitstype(c"struct CThostFtdcExchangeOrderInsertErrorField")
const cCtpInputOrderAction                 = bitstype(c"struct CThostFtdcInputOrderActionField")
const cCtpOrderAction                      = bitstype(c"struct CThostFtdcOrderActionField")
const cCtpExchangeOrderAction              = bitstype(c"struct CThostFtdcExchangeOrderActionField")
const cCtpExchangeOrderActionError         = bitstype(c"struct CThostFtdcExchangeOrderActionErrorField")
const cCtpExchangeTrade                    = bitstype(c"struct CThostFtdcExchangeTradeField")
const cCtpTrade                            = bitstype(c"struct CThostFtdcTradeField")
const cCtpUserSession                      = bitstype(c"struct CThostFtdcUserSessionField")
const cCtpQryMaxOrderVolume                = bitstype(c"struct CThostFtdcQryMaxOrderVolumeField")
const cCtpSettlementInfoConfirm            = bitstype(c"struct CThostFtdcSettlementInfoConfirmField")
const cCtpSyncDeposit                      = bitstype(c"struct CThostFtdcSyncDepositField")
const cCtpSyncFundMortgage                 = bitstype(c"struct CThostFtdcSyncFundMortgageField")
const cCtpBrokerSync                       = bitstype(c"struct CThostFtdcBrokerSyncField")
const cCtpSyncingInvestor                  = bitstype(c"struct CThostFtdcSyncingInvestorField")
const cCtpSyncingTradingCode               = bitstype(c"struct CThostFtdcSyncingTradingCodeField")
const cCtpSyncingInvestorGroup             = bitstype(c"struct CThostFtdcSyncingInvestorGroupField")
const cCtpSyncingTradingAccount            = bitstype(c"struct CThostFtdcSyncingTradingAccountField")
const cCtpSyncingInvestorPosition          = bitstype(c"struct CThostFtdcSyncingInvestorPositionField")
const cCtpSyncingInstrumentMarginRate      = bitstype(c"struct CThostFtdcSyncingInstrumentMarginRateField")
const cCtpSyncingInstrumentCommissionRate  = bitstype(c"struct CThostFtdcSyncingInstrumentCommissionRateField")
const cCtpSyncingInstrumentTradingRight    = bitstype(c"struct CThostFtdcSyncingInstrumentTradingRightField")
const cCtpQryOrder                         = bitstype(c"struct CThostFtdcQryOrderField")
const cCtpQryTrade                         = bitstype(c"struct CThostFtdcQryTradeField")
const cCtpQryInvestorPosition              = bitstype(c"struct CThostFtdcQryInvestorPositionField")
const cCtpQryTradingAccount                = bitstype(c"struct CThostFtdcQryTradingAccountField")
const cCtpQryInvestor                      = bitstype(c"struct CThostFtdcQryInvestorField")
const cCtpQryTradingCode                   = bitstype(c"struct CThostFtdcQryTradingCodeField")
const cCtpQryInvestorGroup                 = bitstype(c"struct CThostFtdcQryInvestorGroupField")
const cCtpQryInstrumentMarginRate          = bitstype(c"struct CThostFtdcQryInstrumentMarginRateField")
const cCtpQryInstrumentCommissionRate      = bitstype(c"struct CThostFtdcQryInstrumentCommissionRateField")
const cCtpQryInstrumentTradingRight        = bitstype(c"struct CThostFtdcQryInstrumentTradingRightField")
const cCtpQryBroker                        = bitstype(c"struct CThostFtdcQryBrokerField")
const cCtpQryTrader                        = bitstype(c"struct CThostFtdcQryTraderField")
const cCtpQrySuperUserFunction             = bitstype(c"struct CThostFtdcQrySuperUserFunctionField")
const cCtpQryUserSession                   = bitstype(c"struct CThostFtdcQryUserSessionField")
const cCtpQryPartBroker                    = bitstype(c"struct CThostFtdcQryPartBrokerField")
const cCtpQryFrontStatus                   = bitstype(c"struct CThostFtdcQryFrontStatusField")
const cCtpQryExchangeOrder                 = bitstype(c"struct CThostFtdcQryExchangeOrderField")
const cCtpQryOrderAction                   = bitstype(c"struct CThostFtdcQryOrderActionField")
const cCtpQryExchangeOrderAction           = bitstype(c"struct CThostFtdcQryExchangeOrderActionField")
const cCtpQrySuperUser                     = bitstype(c"struct CThostFtdcQrySuperUserField")
const cCtpQryExchange                      = bitstype(c"struct CThostFtdcQryExchangeField")
const cCtpQryProduct                       = bitstype(c"struct CThostFtdcQryProductField")
const cCtpQryInstrument                    = bitstype(c"struct CThostFtdcQryInstrumentField")
const cCtpQryDepthMarketData               = bitstype(c"struct CThostFtdcQryDepthMarketDataField")
const cCtpQryBrokerUser                    = bitstype(c"struct CThostFtdcQryBrokerUserField")
const cCtpQryBrokerUserFunction            = bitstype(c"struct CThostFtdcQryBrokerUserFunctionField")
const cCtpQryTraderOffer                   = bitstype(c"struct CThostFtdcQryTraderOfferField")
const cCtpQrySyncDeposit                   = bitstype(c"struct CThostFtdcQrySyncDepositField")
const cCtpQrySettlementInfo                = bitstype(c"struct CThostFtdcQrySettlementInfoField")
const cCtpQryExchangeMarginRate            = bitstype(c"struct CThostFtdcQryExchangeMarginRateField")
const cCtpQryExchangeMarginRateAdjust      = bitstype(c"struct CThostFtdcQryExchangeMarginRateAdjustField")
const cCtpQryExchangeRate                  = bitstype(c"struct CThostFtdcQryExchangeRateField")
const cCtpQrySyncFundMortgage              = bitstype(c"struct CThostFtdcQrySyncFundMortgageField")
const cCtpQryHisOrder                      = bitstype(c"struct CThostFtdcQryHisOrderField")
const cCtpOptionInstrMiniMargin            = bitstype(c"struct CThostFtdcOptionInstrMiniMarginField")
const cCtpOptionInstrMarginAdjust          = bitstype(c"struct CThostFtdcOptionInstrMarginAdjustField")
const cCtpOptionInstrCommRate              = bitstype(c"struct CThostFtdcOptionInstrCommRateField")
const cCtpOptionInstrTradeCost             = bitstype(c"struct CThostFtdcOptionInstrTradeCostField")
const cCtpQryOptionInstrTradeCost          = bitstype(c"struct CThostFtdcQryOptionInstrTradeCostField")
const cCtpQryOptionInstrCommRate           = bitstype(c"struct CThostFtdcQryOptionInstrCommRateField")
const cCtpIndexPrice                       = bitstype(c"struct CThostFtdcIndexPriceField")
const cCtpInputExecOrder                   = bitstype(c"struct CThostFtdcInputExecOrderField")
const cCtpInputExecOrderAction             = bitstype(c"struct CThostFtdcInputExecOrderActionField")
const cCtpExecOrder                        = bitstype(c"struct CThostFtdcExecOrderField")
const cCtpExecOrderAction                  = bitstype(c"struct CThostFtdcExecOrderActionField")
const cCtpQryExecOrder                     = bitstype(c"struct CThostFtdcQryExecOrderField")
const cCtpExchangeExecOrder                = bitstype(c"struct CThostFtdcExchangeExecOrderField")
const cCtpQryExchangeExecOrder             = bitstype(c"struct CThostFtdcQryExchangeExecOrderField")
const cCtpQryExecOrderAction               = bitstype(c"struct CThostFtdcQryExecOrderActionField")
const cCtpExchangeExecOrderAction          = bitstype(c"struct CThostFtdcExchangeExecOrderActionField")
const cCtpQryExchangeExecOrderAction       = bitstype(c"struct CThostFtdcQryExchangeExecOrderActionField")
const cCtpErrExecOrder                     = bitstype(c"struct CThostFtdcErrExecOrderField")
const cCtpQryErrExecOrder                  = bitstype(c"struct CThostFtdcQryErrExecOrderField")
const cCtpErrExecOrderAction               = bitstype(c"struct CThostFtdcErrExecOrderActionField")
const cCtpQryErrExecOrderAction            = bitstype(c"struct CThostFtdcQryErrExecOrderActionField")
const cCtpOptionInstrTradingRight          = bitstype(c"struct CThostFtdcOptionInstrTradingRightField")
const cCtpQryOptionInstrTradingRight       = bitstype(c"struct CThostFtdcQryOptionInstrTradingRightField")
const cCtpInputForQuote                    = bitstype(c"struct CThostFtdcInputForQuoteField")
const cCtpForQuote                         = bitstype(c"struct CThostFtdcForQuoteField")
const cCtpQryForQuote                      = bitstype(c"struct CThostFtdcQryForQuoteField")
const cCtpExchangeForQuote                 = bitstype(c"struct CThostFtdcExchangeForQuoteField")
const cCtpQryExchangeForQuote              = bitstype(c"struct CThostFtdcQryExchangeForQuoteField")
const cCtpInputQuote                       = bitstype(c"struct CThostFtdcInputQuoteField")
const cCtpInputQuoteAction                 = bitstype(c"struct CThostFtdcInputQuoteActionField")
const cCtpQuote                            = bitstype(c"struct CThostFtdcQuoteField")
const cCtpQuoteAction                      = bitstype(c"struct CThostFtdcQuoteActionField")
const cCtpQryQuote                         = bitstype(c"struct CThostFtdcQryQuoteField")
const cCtpExchangeQuote                    = bitstype(c"struct CThostFtdcExchangeQuoteField")
const cCtpQryExchangeQuote                 = bitstype(c"struct CThostFtdcQryExchangeQuoteField")
const cCtpQryQuoteAction                   = bitstype(c"struct CThostFtdcQryQuoteActionField")
const cCtpExchangeQuoteAction              = bitstype(c"struct CThostFtdcExchangeQuoteActionField")
const cCtpQryExchangeQuoteAction           = bitstype(c"struct CThostFtdcQryExchangeQuoteActionField")
const cCtpOptionInstrDelta                 = bitstype(c"struct CThostFtdcOptionInstrDeltaField")
const cCtpForQuoteRsp                      = bitstype(c"struct CThostFtdcForQuoteRspField")
const cCtpStrikeOffset                     = bitstype(c"struct CThostFtdcStrikeOffsetField")
const cCtpQryStrikeOffset                  = bitstype(c"struct CThostFtdcQryStrikeOffsetField")
const cCtpInputBatchOrderAction            = bitstype(c"struct CThostFtdcInputBatchOrderActionField")
const cCtpBatchOrderAction                 = bitstype(c"struct CThostFtdcBatchOrderActionField")
const cCtpExchangeBatchOrderAction         = bitstype(c"struct CThostFtdcExchangeBatchOrderActionField")
const cCtpQryBatchOrderAction              = bitstype(c"struct CThostFtdcQryBatchOrderActionField")
const cCtpCombInstrumentGuard              = bitstype(c"struct CThostFtdcCombInstrumentGuardField")
const cCtpQryCombInstrumentGuard           = bitstype(c"struct CThostFtdcQryCombInstrumentGuardField")
const cCtpInputCombAction                  = bitstype(c"struct CThostFtdcInputCombActionField")
const cCtpCombAction                       = bitstype(c"struct CThostFtdcCombActionField")
const cCtpQryCombAction                    = bitstype(c"struct CThostFtdcQryCombActionField")
const cCtpExchangeCombAction               = bitstype(c"struct CThostFtdcExchangeCombActionField")
const cCtpQryExchangeCombAction            = bitstype(c"struct CThostFtdcQryExchangeCombActionField")
const cCtpProductExchRate                  = bitstype(c"struct CThostFtdcProductExchRateField")
const cCtpQryProductExchRate               = bitstype(c"struct CThostFtdcQryProductExchRateField")
const cCtpQryForQuoteParam                 = bitstype(c"struct CThostFtdcQryForQuoteParamField")
const cCtpForQuoteParam                    = bitstype(c"struct CThostFtdcForQuoteParamField")
const cCtpMMOptionInstrCommRate            = bitstype(c"struct CThostFtdcMMOptionInstrCommRateField")
const cCtpQryMMOptionInstrCommRate         = bitstype(c"struct CThostFtdcQryMMOptionInstrCommRateField")
const cCtpMMInstrumentCommissionRate       = bitstype(c"struct CThostFtdcMMInstrumentCommissionRateField")
const cCtpQryMMInstrumentCommissionRate    = bitstype(c"struct CThostFtdcQryMMInstrumentCommissionRateField")
const cCtpInstrumentOrderCommRate          = bitstype(c"struct CThostFtdcInstrumentOrderCommRateField")
const cCtpQryInstrumentOrderCommRate       = bitstype(c"struct CThostFtdcQryInstrumentOrderCommRateField")
const cCtpTradeParam                       = bitstype(c"struct CThostFtdcTradeParamField")
const cCtpInstrumentMarginRateUL           = bitstype(c"struct CThostFtdcInstrumentMarginRateULField")
const cCtpFutureLimitPosiParam             = bitstype(c"struct CThostFtdcFutureLimitPosiParamField")
const cCtpLoginForbiddenIP                 = bitstype(c"struct CThostFtdcLoginForbiddenIPField")
const cCtpIPList                           = bitstype(c"struct CThostFtdcIPListField")
const cCtpInputOptionSelfClose             = bitstype(c"struct CThostFtdcInputOptionSelfCloseField")
const cCtpInputOptionSelfCloseAction       = bitstype(c"struct CThostFtdcInputOptionSelfCloseActionField")
const cCtpOptionSelfClose                  = bitstype(c"struct CThostFtdcOptionSelfCloseField")
const cCtpOptionSelfCloseAction            = bitstype(c"struct CThostFtdcOptionSelfCloseActionField")
const cCtpQryOptionSelfClose               = bitstype(c"struct CThostFtdcQryOptionSelfCloseField")
const cCtpExchangeOptionSelfClose          = bitstype(c"struct CThostFtdcExchangeOptionSelfCloseField")
const cCtpQryOptionSelfCloseAction         = bitstype(c"struct CThostFtdcQryOptionSelfCloseActionField")
const cCtpExchangeOptionSelfCloseAction    = bitstype(c"struct CThostFtdcExchangeOptionSelfCloseActionField")
const cCtpSyncDelaySwap                    = bitstype(c"struct CThostFtdcSyncDelaySwapField")
const cCtpQrySyncDelaySwap                 = bitstype(c"struct CThostFtdcQrySyncDelaySwapField")
const cCtpInvestUnit                       = bitstype(c"struct CThostFtdcInvestUnitField")
const cCtpQryInvestUnit                    = bitstype(c"struct CThostFtdcQryInvestUnitField")
const cCtpSecAgentCheckMode                = bitstype(c"struct CThostFtdcSecAgentCheckModeField")
const cCtpSecAgentTradeInfo                = bitstype(c"struct CThostFtdcSecAgentTradeInfoField")
const cCtpMarketData                       = bitstype(c"struct CThostFtdcMarketDataField")
const cCtpMarketDataBase                   = bitstype(c"struct CThostFtdcMarketDataBaseField")
const cCtpMarketDataStatic                 = bitstype(c"struct CThostFtdcMarketDataStaticField")
const cCtpMarketDataLastMatch              = bitstype(c"struct CThostFtdcMarketDataLastMatchField")
const cCtpMarketDataBestPrice              = bitstype(c"struct CThostFtdcMarketDataBestPriceField")
const cCtpMarketDataBid23                  = bitstype(c"struct CThostFtdcMarketDataBid23Field")
const cCtpMarketDataAsk23                  = bitstype(c"struct CThostFtdcMarketDataAsk23Field")
const cCtpMarketDataBid45                  = bitstype(c"struct CThostFtdcMarketDataBid45Field")
const cCtpMarketDataAsk45                  = bitstype(c"struct CThostFtdcMarketDataAsk45Field")
const cCtpMarketDataUpdateTime             = bitstype(c"struct CThostFtdcMarketDataUpdateTimeField")
const cCtpMarketDataBandingPrice           = bitstype(c"struct CThostFtdcMarketDataBandingPriceField")
const cCtpMarketDataExchange               = bitstype(c"struct CThostFtdcMarketDataExchangeField")
const cCtpSpecificInstrument               = bitstype(c"struct CThostFtdcSpecificInstrumentField")
const cCtpInstrumentStatus                 = bitstype(c"struct CThostFtdcInstrumentStatusField")
const cCtpQryInstrumentStatus              = bitstype(c"struct CThostFtdcQryInstrumentStatusField")
const cCtpInvestorAccount                  = bitstype(c"struct CThostFtdcInvestorAccountField")
const cCtpPositionProfitAlgorithm          = bitstype(c"struct CThostFtdcPositionProfitAlgorithmField")
const cCtpDiscount                         = bitstype(c"struct CThostFtdcDiscountField")
const cCtpQryTransferBank                  = bitstype(c"struct CThostFtdcQryTransferBankField")
const cCtpTransferBank                     = bitstype(c"struct CThostFtdcTransferBankField")
const cCtpQryInvestorPositionDetail        = bitstype(c"struct CThostFtdcQryInvestorPositionDetailField")
const cCtpInvestorPositionDetail           = bitstype(c"struct CThostFtdcInvestorPositionDetailField")
const cCtpTradingAccountPassword           = bitstype(c"struct CThostFtdcTradingAccountPasswordField")
const cCtpMDTraderOffer                    = bitstype(c"struct CThostFtdcMDTraderOfferField")
const cCtpQryMDTraderOffer                 = bitstype(c"struct CThostFtdcQryMDTraderOfferField")
const cCtpQryNotice                        = bitstype(c"struct CThostFtdcQryNoticeField")
const cCtpNotice                           = bitstype(c"struct CThostFtdcNoticeField")
const cCtpUserRight                        = bitstype(c"struct CThostFtdcUserRightField")
const cCtpQrySettlementInfoConfirm         = bitstype(c"struct CThostFtdcQrySettlementInfoConfirmField")
const cCtpLoadSettlementInfo               = bitstype(c"struct CThostFtdcLoadSettlementInfoField")
const cCtpBrokerWithdrawAlgorithm          = bitstype(c"struct CThostFtdcBrokerWithdrawAlgorithmField")
const cCtpTradingAccountPasswordUpdateV1   = bitstype(c"struct CThostFtdcTradingAccountPasswordUpdateV1Field")
const cCtpTradingAccountPasswordUpdate     = bitstype(c"struct CThostFtdcTradingAccountPasswordUpdateField")
const cCtpQryCombinationLeg                = bitstype(c"struct CThostFtdcQryCombinationLegField")
const cCtpQrySyncStatus                    = bitstype(c"struct CThostFtdcQrySyncStatusField")
const cCtpCombinationLeg                   = bitstype(c"struct CThostFtdcCombinationLegField")
const cCtpSyncStatus                       = bitstype(c"struct CThostFtdcSyncStatusField")
const cCtpQryLinkMan                       = bitstype(c"struct CThostFtdcQryLinkManField")
const cCtpLinkMan                          = bitstype(c"struct CThostFtdcLinkManField")
const cCtpQryBrokerUserEvent               = bitstype(c"struct CThostFtdcQryBrokerUserEventField")
const cCtpBrokerUserEvent                  = bitstype(c"struct CThostFtdcBrokerUserEventField")
const cCtpQryContractBank                  = bitstype(c"struct CThostFtdcQryContractBankField")
const cCtpContractBank                     = bitstype(c"struct CThostFtdcContractBankField")
const cCtpInvestorPositionCombineDetail    = bitstype(c"struct CThostFtdcInvestorPositionCombineDetailField")
const cCtpParkedOrder                      = bitstype(c"struct CThostFtdcParkedOrderField")
const cCtpParkedOrderAction                = bitstype(c"struct CThostFtdcParkedOrderActionField")
const cCtpQryParkedOrder                   = bitstype(c"struct CThostFtdcQryParkedOrderField")
const cCtpQryParkedOrderAction             = bitstype(c"struct CThostFtdcQryParkedOrderActionField")
const cCtpRemoveParkedOrder                = bitstype(c"struct CThostFtdcRemoveParkedOrderField")
const cCtpRemoveParkedOrderAction          = bitstype(c"struct CThostFtdcRemoveParkedOrderActionField")
const cCtpInvestorWithdrawAlgorithm        = bitstype(c"struct CThostFtdcInvestorWithdrawAlgorithmField")
const cCtpQryInvestorPositionCombineDetail = bitstype(c"struct CThostFtdcQryInvestorPositionCombineDetailField")
const cCtpMarketDataAveragePrice           = bitstype(c"struct CThostFtdcMarketDataAveragePriceField")
const cCtpVerifyInvestorPassword           = bitstype(c"struct CThostFtdcVerifyInvestorPasswordField")
const cCtpUserIP                           = bitstype(c"struct CThostFtdcUserIPField")
const cCtpTradingNoticeInfo                = bitstype(c"struct CThostFtdcTradingNoticeInfoField")
const cCtpTradingNotice                    = bitstype(c"struct CThostFtdcTradingNoticeField")
const cCtpQryTradingNotice                 = bitstype(c"struct CThostFtdcQryTradingNoticeField")
const cCtpQryErrOrder                      = bitstype(c"struct CThostFtdcQryErrOrderField")
const cCtpErrOrder                         = bitstype(c"struct CThostFtdcErrOrderField")
const cCtpErrorConditionalOrder            = bitstype(c"struct CThostFtdcErrorConditionalOrderField")
const cCtpQryErrOrderAction                = bitstype(c"struct CThostFtdcQryErrOrderActionField")
const cCtpErrOrderAction                   = bitstype(c"struct CThostFtdcErrOrderActionField")
const cCtpQryExchangeSequence              = bitstype(c"struct CThostFtdcQryExchangeSequenceField")
const cCtpExchangeSequence                 = bitstype(c"struct CThostFtdcExchangeSequenceField")
const cCtpQryMaxOrderVolumeWithPrice       = bitstype(c"struct CThostFtdcQryMaxOrderVolumeWithPriceField")
const cCtpQryBrokerTradingParams           = bitstype(c"struct CThostFtdcQryBrokerTradingParamsField")
const cCtpBrokerTradingParams              = bitstype(c"struct CThostFtdcBrokerTradingParamsField")
const cCtpQryBrokerTradingAlgos            = bitstype(c"struct CThostFtdcQryBrokerTradingAlgosField")
const cCtpBrokerTradingAlgos               = bitstype(c"struct CThostFtdcBrokerTradingAlgosField")
const cCtpQueryBrokerDeposit               = bitstype(c"struct CThostFtdcQueryBrokerDepositField")
const cCtpBrokerDeposit                    = bitstype(c"struct CThostFtdcBrokerDepositField")
const cCtpQryCFMMCBrokerKey                = bitstype(c"struct CThostFtdcQryCFMMCBrokerKeyField")
const cCtpCFMMCBrokerKey                   = bitstype(c"struct CThostFtdcCFMMCBrokerKeyField")
const cCtpCFMMCTradingAccountKey           = bitstype(c"struct CThostFtdcCFMMCTradingAccountKeyField")
const cCtpQryCFMMCTradingAccountKey        = bitstype(c"struct CThostFtdcQryCFMMCTradingAccountKeyField")
const cCtpBrokerUserOTPParam               = bitstype(c"struct CThostFtdcBrokerUserOTPParamField")
const cCtpManualSyncBrokerUserOTP          = bitstype(c"struct CThostFtdcManualSyncBrokerUserOTPField")
const cCtpCommRateModel                    = bitstype(c"struct CThostFtdcCommRateModelField")
const cCtpQryCommRateModel                 = bitstype(c"struct CThostFtdcQryCommRateModelField")
const cCtpMarginModel                      = bitstype(c"struct CThostFtdcMarginModelField")
const cCtpQryMarginModel                   = bitstype(c"struct CThostFtdcQryMarginModelField")
const cCtpEWarrantOffset                   = bitstype(c"struct CThostFtdcEWarrantOffsetField")
const cCtpQryEWarrantOffset                = bitstype(c"struct CThostFtdcQryEWarrantOffsetField")
const cCtpQryInvestorProductGroupMargin    = bitstype(c"struct CThostFtdcQryInvestorProductGroupMarginField")
const cCtpInvestorProductGroupMargin       = bitstype(c"struct CThostFtdcInvestorProductGroupMarginField")
const cCtpQueryCFMMCTradingAccountToken    = bitstype(c"struct CThostFtdcQueryCFMMCTradingAccountTokenField")
const cCtpCFMMCTradingAccountToken         = bitstype(c"struct CThostFtdcCFMMCTradingAccountTokenField")
const cCtpQryProductGroup                  = bitstype(c"struct CThostFtdcQryProductGroupField")
const cCtpProductGroup                     = bitstype(c"struct CThostFtdcProductGroupField")
const cCtpBulletin                         = bitstype(c"struct CThostFtdcBulletinField")
const cCtpQryBulletin                      = bitstype(c"struct CThostFtdcQryBulletinField")
const cCtpMulticastInstrument              = bitstype(c"struct CThostFtdcMulticastInstrumentField")
const cCtpQryMulticastInstrument           = bitstype(c"struct CThostFtdcQryMulticastInstrumentField")
const cCtpAppIDAuthAssign                  = bitstype(c"struct CThostFtdcAppIDAuthAssignField")
const cCtpReqOpenAccount                   = bitstype(c"struct CThostFtdcReqOpenAccountField")
const cCtpReqCancelAccount                 = bitstype(c"struct CThostFtdcReqCancelAccountField")
const cCtpReqChangeAccount                 = bitstype(c"struct CThostFtdcReqChangeAccountField")
const cCtpReqTransfer                      = bitstype(c"struct CThostFtdcReqTransferField")
const cCtpRspTransfer                      = bitstype(c"struct CThostFtdcRspTransferField")
const cCtpReqRepeal                        = bitstype(c"struct CThostFtdcReqRepealField")
const cCtpRspRepeal                        = bitstype(c"struct CThostFtdcRspRepealField")
const cCtpReqQueryAccount                  = bitstype(c"struct CThostFtdcReqQueryAccountField")
const cCtpRspQueryAccount                  = bitstype(c"struct CThostFtdcRspQueryAccountField")
const cCtpFutureSignIO                     = bitstype(c"struct CThostFtdcFutureSignIOField")
const cCtpRspFutureSignIn                  = bitstype(c"struct CThostFtdcRspFutureSignInField")
const cCtpReqFutureSignOut                 = bitstype(c"struct CThostFtdcReqFutureSignOutField")
const cCtpRspFutureSignOut                 = bitstype(c"struct CThostFtdcRspFutureSignOutField")
const cCtpReqQueryTradeResultBySerial      = bitstype(c"struct CThostFtdcReqQueryTradeResultBySerialField")
const cCtpRspQueryTradeResultBySerial      = bitstype(c"struct CThostFtdcRspQueryTradeResultBySerialField")
const cCtpReqDayEndFileReady               = bitstype(c"struct CThostFtdcReqDayEndFileReadyField")
const cCtpReturnResult                     = bitstype(c"struct CThostFtdcReturnResultField")
const cCtpVerifyFuturePassword             = bitstype(c"struct CThostFtdcVerifyFuturePasswordField")
const cCtpVerifyCustInfo                   = bitstype(c"struct CThostFtdcVerifyCustInfoField")
const cCtpVerifyFuturePasswordAndCustInfo  = bitstype(c"struct CThostFtdcVerifyFuturePasswordAndCustInfoField")
const cCtpDepositResultInform              = bitstype(c"struct CThostFtdcDepositResultInformField")
const cCtpReqSyncKey                       = bitstype(c"struct CThostFtdcReqSyncKeyField")
const cCtpRspSyncKey                       = bitstype(c"struct CThostFtdcRspSyncKeyField")
const cCtpNotifyQueryAccount               = bitstype(c"struct CThostFtdcNotifyQueryAccountField")
const cCtpTransferSerial                   = bitstype(c"struct CThostFtdcTransferSerialField")
const cCtpQryTransferSerial                = bitstype(c"struct CThostFtdcQryTransferSerialField")
const cCtpNotifyFutureSignIn               = bitstype(c"struct CThostFtdcNotifyFutureSignInField")
const cCtpNotifyFutureSignOut              = bitstype(c"struct CThostFtdcNotifyFutureSignOutField")
const cCtpNotifySyncKey                    = bitstype(c"struct CThostFtdcNotifySyncKeyField")
const cCtpQryAccountregister               = bitstype(c"struct CThostFtdcQryAccountregisterField")
const cCtpAccountregister                  = bitstype(c"struct CThostFtdcAccountregisterField")
const cCtpOpenAccount                      = bitstype(c"struct CThostFtdcOpenAccountField")
const cCtpCancelAccount                    = bitstype(c"struct CThostFtdcCancelAccountField")
const cCtpChangeAccount                    = bitstype(c"struct CThostFtdcChangeAccountField")
const cCtpSecAgentACIDMap                  = bitstype(c"struct CThostFtdcSecAgentACIDMapField")
const cCtpQrySecAgentACIDMap               = bitstype(c"struct CThostFtdcQrySecAgentACIDMapField")
const cCtpUserRightsAssign                 = bitstype(c"struct CThostFtdcUserRightsAssignField")
const cCtpBrokerUserRightAssign            = bitstype(c"struct CThostFtdcBrokerUserRightAssignField")
const cCtpDRTransfer                       = bitstype(c"struct CThostFtdcDRTransferField")
const cCtpFensUserInfo                     = bitstype(c"struct CThostFtdcFensUserInfoField")
const cCtpCurrTransferIdentity             = bitstype(c"struct CThostFtdcCurrTransferIdentityField")
const cCtpLoginForbiddenUser               = bitstype(c"struct CThostFtdcLoginForbiddenUserField")
const cCtpQryLoginForbiddenUser            = bitstype(c"struct CThostFtdcQryLoginForbiddenUserField")
const cCtpTradingAccountReserve            = bitstype(c"struct CThostFtdcTradingAccountReserveField")
const cCtpQryLoginForbiddenIP              = bitstype(c"struct CThostFtdcQryLoginForbiddenIPField")
const cCtpQryIPList                        = bitstype(c"struct CThostFtdcQryIPListField")
const cCtpQryUserRightsAssign              = bitstype(c"struct CThostFtdcQryUserRightsAssignField")
const cCtpReserveOpenAccountConfirm        = bitstype(c"struct CThostFtdcReserveOpenAccountConfirmField")
const cCtpReserveOpenAccount               = bitstype(c"struct CThostFtdcReserveOpenAccountField")
const cCtpAccountProperty                  = bitstype(c"struct CThostFtdcAccountPropertyField")
const cCtpQryCurrDRIdentity                = bitstype(c"struct CThostFtdcQryCurrDRIdentityField")
const cCtpCurrDRIdentity                   = bitstype(c"struct CThostFtdcCurrDRIdentityField")
const cCtpQrySecAgentCheckMode             = bitstype(c"struct CThostFtdcQrySecAgentCheckModeField")
const cCtpQrySecAgentTradeInfo             = bitstype(c"struct CThostFtdcQrySecAgentTradeInfoField")
const cCtpReqUserAuthMethod                = bitstype(c"struct CThostFtdcReqUserAuthMethodField")
const cCtpRspUserAuthMethod                = bitstype(c"struct CThostFtdcRspUserAuthMethodField")
const cCtpReqGenUserCaptcha                = bitstype(c"struct CThostFtdcReqGenUserCaptchaField")
const cCtpRspGenUserCaptcha                = bitstype(c"struct CThostFtdcRspGenUserCaptchaField")
const cCtpReqGenUserText                   = bitstype(c"struct CThostFtdcReqGenUserTextField")
const cCtpRspGenUserText                   = bitstype(c"struct CThostFtdcRspGenUserTextField")
const cCtpReqUserLoginWithCaptcha          = bitstype(c"struct CThostFtdcReqUserLoginWithCaptchaField")
const cCtpReqUserLoginWithText             = bitstype(c"struct CThostFtdcReqUserLoginWithTextField")
const cCtpReqUserLoginWithOTP              = bitstype(c"struct CThostFtdcReqUserLoginWithOTPField")
const cCtpReqApiHandshake                  = bitstype(c"struct CThostFtdcReqApiHandshakeField")
const cCtpRspApiHandshake                  = bitstype(c"struct CThostFtdcRspApiHandshakeField")
const cCtpReqVerifyApiKey                  = bitstype(c"struct CThostFtdcReqVerifyApiKeyField")
const cCtpDepartmentUser                   = bitstype(c"struct CThostFtdcDepartmentUserField")
const cCtpQueryFreq                        = bitstype(c"struct CThostFtdcQueryFreqField")
const cCtpAuthForbiddenIP                  = bitstype(c"struct CThostFtdcAuthForbiddenIPField")
const cCtpQryAuthForbiddenIP               = bitstype(c"struct CThostFtdcQryAuthForbiddenIPField")
const cCtpSyncDelaySwapFrozen              = bitstype(c"struct CThostFtdcSyncDelaySwapFrozenField")
const cCtpUserSystemInfo                   = bitstype(c"struct CThostFtdcUserSystemInfoField")
const cCtpAuthUserID                       = bitstype(c"struct CThostFtdcAuthUserIDField")
const cCtpAuthIP                           = bitstype(c"struct CThostFtdcAuthIPField")
const cCtpQryClassifiedInstrument          = bitstype(c"struct CThostFtdcQryClassifiedInstrumentField")
const cCtpQryCombPromotionParam            = bitstype(c"struct CThostFtdcQryCombPromotionParamField")
const cCtpCombPromotionParam               = bitstype(c"struct CThostFtdcCombPromotionParamField")
const cCtpQryRiskSettleInvstPosition       = bitstype(c"struct CThostFtdcQryRiskSettleInvstPositionField")
const cCtpQryRiskSettleProductStatus       = bitstype(c"struct CThostFtdcQryRiskSettleProductStatusField")
const cCtpRiskSettleInvstPosition          = bitstype(c"struct CThostFtdcRiskSettleInvstPositionField")
const cCtpRiskSettleProductStatus          = bitstype(c"struct CThostFtdcRiskSettleProductStatusField")
const cCtpSyncDeltaInfo                    = bitstype(c"struct CThostFtdcSyncDeltaInfoField")
const cCtpSyncDeltaProductStatus           = bitstype(c"struct CThostFtdcSyncDeltaProductStatusField")
const cCtpSyncDeltaInvstPosDtl             = bitstype(c"struct CThostFtdcSyncDeltaInvstPosDtlField")
const cCtpSyncDeltaInvstPosCombDtl         = bitstype(c"struct CThostFtdcSyncDeltaInvstPosCombDtlField")
const cCtpSyncDeltaTradingAccount          = bitstype(c"struct CThostFtdcSyncDeltaTradingAccountField")
const cCtpSyncDeltaInitInvstMargin         = bitstype(c"struct CThostFtdcSyncDeltaInitInvstMarginField")
const cCtpSyncDeltaDceCombInstrument       = bitstype(c"struct CThostFtdcSyncDeltaDceCombInstrumentField")
const cCtpSyncDeltaInvstMarginRate         = bitstype(c"struct CThostFtdcSyncDeltaInvstMarginRateField")
const cCtpSyncDeltaExchMarginRate          = bitstype(c"struct CThostFtdcSyncDeltaExchMarginRateField")
const cCtpSyncDeltaOptExchMargin           = bitstype(c"struct CThostFtdcSyncDeltaOptExchMarginField")
const cCtpSyncDeltaOptInvstMargin          = bitstype(c"struct CThostFtdcSyncDeltaOptInvstMarginField")
const cCtpSyncDeltaInvstMarginRateUL       = bitstype(c"struct CThostFtdcSyncDeltaInvstMarginRateULField")
const cCtpSyncDeltaOptInvstCommRate        = bitstype(c"struct CThostFtdcSyncDeltaOptInvstCommRateField")
const cCtpSyncDeltaInvstCommRate           = bitstype(c"struct CThostFtdcSyncDeltaInvstCommRateField")
const cCtpSyncDeltaProductExchRate         = bitstype(c"struct CThostFtdcSyncDeltaProductExchRateField")
const cCtpSyncDeltaDepthMarketData         = bitstype(c"struct CThostFtdcSyncDeltaDepthMarketDataField")
const cCtpSyncDeltaIndexPrice              = bitstype(c"struct CThostFtdcSyncDeltaIndexPriceField")
const cCtpSyncDeltaEWarrantOffset          = bitstype(c"struct CThostFtdcSyncDeltaEWarrantOffsetField")


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
