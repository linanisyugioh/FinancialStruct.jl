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
#         共 386 个，全部自动生成于此（与上游头文件 1:1 对齐）
cCtpDissemination                    = bitstype(c"struct CThostFtdcDisseminationField")
cCtpReqUserLogin                     = bitstype(c"struct CThostFtdcReqUserLoginField")
cCtpRspUserLogin                     = bitstype(c"struct CThostFtdcRspUserLoginField")
cCtpUserLogout                       = bitstype(c"struct CThostFtdcUserLogoutField")
cCtpForceUserLogout                  = bitstype(c"struct CThostFtdcForceUserLogoutField")
cCtpReqAuthenticate                  = bitstype(c"struct CThostFtdcReqAuthenticateField")
cCtpRspAuthenticate                  = bitstype(c"struct CThostFtdcRspAuthenticateField")
cCtpAuthenticationInfo               = bitstype(c"struct CThostFtdcAuthenticationInfoField")
cCtpRspUserLogin2                    = bitstype(c"struct CThostFtdcRspUserLogin2Field")
cCtpTransferHeader                   = bitstype(c"struct CThostFtdcTransferHeaderField")
cCtpTransferBankToFutureReq          = bitstype(c"struct CThostFtdcTransferBankToFutureReqField")
cCtpTransferBankToFutureRsp          = bitstype(c"struct CThostFtdcTransferBankToFutureRspField")
cCtpTransferFutureToBankReq          = bitstype(c"struct CThostFtdcTransferFutureToBankReqField")
cCtpTransferFutureToBankRsp          = bitstype(c"struct CThostFtdcTransferFutureToBankRspField")
cCtpTransferQryBankReq               = bitstype(c"struct CThostFtdcTransferQryBankReqField")
cCtpTransferQryBankRsp               = bitstype(c"struct CThostFtdcTransferQryBankRspField")
cCtpTransferQryDetailReq             = bitstype(c"struct CThostFtdcTransferQryDetailReqField")
cCtpTransferQryDetailRsp             = bitstype(c"struct CThostFtdcTransferQryDetailRspField")
cCtpRspInfo                          = bitstype(c"struct CThostFtdcRspInfoField")
cCtpExchange                         = bitstype(c"struct CThostFtdcExchangeField")
cCtpProduct                          = bitstype(c"struct CThostFtdcProductField")
cCtpInstrument                       = bitstype(c"struct CThostFtdcInstrumentField")
cCtpBroker                           = bitstype(c"struct CThostFtdcBrokerField")
cCtpTrader                           = bitstype(c"struct CThostFtdcTraderField")
cCtpInvestor                         = bitstype(c"struct CThostFtdcInvestorField")
cCtpTradingCode                      = bitstype(c"struct CThostFtdcTradingCodeField")
cCtpPartBroker                       = bitstype(c"struct CThostFtdcPartBrokerField")
cCtpSuperUser                        = bitstype(c"struct CThostFtdcSuperUserField")
cCtpSuperUserFunction                = bitstype(c"struct CThostFtdcSuperUserFunctionField")
cCtpInvestorGroup                    = bitstype(c"struct CThostFtdcInvestorGroupField")
cCtpTradingAccount                   = bitstype(c"struct CThostFtdcTradingAccountField")
cCtpInvestorPosition                 = bitstype(c"struct CThostFtdcInvestorPositionField")
cCtpInstrumentMarginRate             = bitstype(c"struct CThostFtdcInstrumentMarginRateField")
cCtpInstrumentCommissionRate         = bitstype(c"struct CThostFtdcInstrumentCommissionRateField")
cCtpDepthMarketData                  = bitstype(c"struct CThostFtdcDepthMarketDataField")
cCtpInstrumentTradingRight           = bitstype(c"struct CThostFtdcInstrumentTradingRightField")
cCtpBrokerUser                       = bitstype(c"struct CThostFtdcBrokerUserField")
cCtpBrokerUserPassword               = bitstype(c"struct CThostFtdcBrokerUserPasswordField")
cCtpBrokerUserFunction               = bitstype(c"struct CThostFtdcBrokerUserFunctionField")
cCtpTraderOffer                      = bitstype(c"struct CThostFtdcTraderOfferField")
cCtpSettlementInfo                   = bitstype(c"struct CThostFtdcSettlementInfoField")
cCtpInstrumentMarginRateAdjust       = bitstype(c"struct CThostFtdcInstrumentMarginRateAdjustField")
cCtpExchangeMarginRate               = bitstype(c"struct CThostFtdcExchangeMarginRateField")
cCtpExchangeMarginRateAdjust         = bitstype(c"struct CThostFtdcExchangeMarginRateAdjustField")
cCtpExchangeRate                     = bitstype(c"struct CThostFtdcExchangeRateField")
cCtpSettlementRef                    = bitstype(c"struct CThostFtdcSettlementRefField")
cCtpCurrentTime                      = bitstype(c"struct CThostFtdcCurrentTimeField")
cCtpCommPhase                        = bitstype(c"struct CThostFtdcCommPhaseField")
cCtpLoginInfo                        = bitstype(c"struct CThostFtdcLoginInfoField")
cCtpLogoutAll                        = bitstype(c"struct CThostFtdcLogoutAllField")
cCtpFrontStatus                      = bitstype(c"struct CThostFtdcFrontStatusField")
cCtpUserPasswordUpdate               = bitstype(c"struct CThostFtdcUserPasswordUpdateField")
cCtpInputOrder                       = bitstype(c"struct CThostFtdcInputOrderField")
cCtpOrder                            = bitstype(c"struct CThostFtdcOrderField")
cCtpExchangeOrder                    = bitstype(c"struct CThostFtdcExchangeOrderField")
cCtpExchangeOrderInsertError         = bitstype(c"struct CThostFtdcExchangeOrderInsertErrorField")
cCtpInputOrderAction                 = bitstype(c"struct CThostFtdcInputOrderActionField")
cCtpOrderAction                      = bitstype(c"struct CThostFtdcOrderActionField")
cCtpExchangeOrderAction              = bitstype(c"struct CThostFtdcExchangeOrderActionField")
cCtpExchangeOrderActionError         = bitstype(c"struct CThostFtdcExchangeOrderActionErrorField")
cCtpExchangeTrade                    = bitstype(c"struct CThostFtdcExchangeTradeField")
cCtpTrade                            = bitstype(c"struct CThostFtdcTradeField")
cCtpUserSession                      = bitstype(c"struct CThostFtdcUserSessionField")
cCtpQryMaxOrderVolume                = bitstype(c"struct CThostFtdcQryMaxOrderVolumeField")
cCtpSettlementInfoConfirm            = bitstype(c"struct CThostFtdcSettlementInfoConfirmField")
cCtpSyncDeposit                      = bitstype(c"struct CThostFtdcSyncDepositField")
cCtpSyncFundMortgage                 = bitstype(c"struct CThostFtdcSyncFundMortgageField")
cCtpBrokerSync                       = bitstype(c"struct CThostFtdcBrokerSyncField")
cCtpSyncingInvestor                  = bitstype(c"struct CThostFtdcSyncingInvestorField")
cCtpSyncingTradingCode               = bitstype(c"struct CThostFtdcSyncingTradingCodeField")
cCtpSyncingInvestorGroup             = bitstype(c"struct CThostFtdcSyncingInvestorGroupField")
cCtpSyncingTradingAccount            = bitstype(c"struct CThostFtdcSyncingTradingAccountField")
cCtpSyncingInvestorPosition          = bitstype(c"struct CThostFtdcSyncingInvestorPositionField")
cCtpSyncingInstrumentMarginRate      = bitstype(c"struct CThostFtdcSyncingInstrumentMarginRateField")
cCtpSyncingInstrumentCommissionRate  = bitstype(c"struct CThostFtdcSyncingInstrumentCommissionRateField")
cCtpSyncingInstrumentTradingRight    = bitstype(c"struct CThostFtdcSyncingInstrumentTradingRightField")
cCtpQryOrder                         = bitstype(c"struct CThostFtdcQryOrderField")
cCtpQryTrade                         = bitstype(c"struct CThostFtdcQryTradeField")
cCtpQryInvestorPosition              = bitstype(c"struct CThostFtdcQryInvestorPositionField")
cCtpQryTradingAccount                = bitstype(c"struct CThostFtdcQryTradingAccountField")
cCtpQryInvestor                      = bitstype(c"struct CThostFtdcQryInvestorField")
cCtpQryTradingCode                   = bitstype(c"struct CThostFtdcQryTradingCodeField")
cCtpQryInvestorGroup                 = bitstype(c"struct CThostFtdcQryInvestorGroupField")
cCtpQryInstrumentMarginRate          = bitstype(c"struct CThostFtdcQryInstrumentMarginRateField")
cCtpQryInstrumentCommissionRate      = bitstype(c"struct CThostFtdcQryInstrumentCommissionRateField")
cCtpQryInstrumentTradingRight        = bitstype(c"struct CThostFtdcQryInstrumentTradingRightField")
cCtpQryBroker                        = bitstype(c"struct CThostFtdcQryBrokerField")
cCtpQryTrader                        = bitstype(c"struct CThostFtdcQryTraderField")
cCtpQrySuperUserFunction             = bitstype(c"struct CThostFtdcQrySuperUserFunctionField")
cCtpQryUserSession                   = bitstype(c"struct CThostFtdcQryUserSessionField")
cCtpQryPartBroker                    = bitstype(c"struct CThostFtdcQryPartBrokerField")
cCtpQryFrontStatus                   = bitstype(c"struct CThostFtdcQryFrontStatusField")
cCtpQryExchangeOrder                 = bitstype(c"struct CThostFtdcQryExchangeOrderField")
cCtpQryOrderAction                   = bitstype(c"struct CThostFtdcQryOrderActionField")
cCtpQryExchangeOrderAction           = bitstype(c"struct CThostFtdcQryExchangeOrderActionField")
cCtpQrySuperUser                     = bitstype(c"struct CThostFtdcQrySuperUserField")
cCtpQryExchange                      = bitstype(c"struct CThostFtdcQryExchangeField")
cCtpQryProduct                       = bitstype(c"struct CThostFtdcQryProductField")
cCtpQryInstrument                    = bitstype(c"struct CThostFtdcQryInstrumentField")
cCtpQryDepthMarketData               = bitstype(c"struct CThostFtdcQryDepthMarketDataField")
cCtpQryBrokerUser                    = bitstype(c"struct CThostFtdcQryBrokerUserField")
cCtpQryBrokerUserFunction            = bitstype(c"struct CThostFtdcQryBrokerUserFunctionField")
cCtpQryTraderOffer                   = bitstype(c"struct CThostFtdcQryTraderOfferField")
cCtpQrySyncDeposit                   = bitstype(c"struct CThostFtdcQrySyncDepositField")
cCtpQrySettlementInfo                = bitstype(c"struct CThostFtdcQrySettlementInfoField")
cCtpQryExchangeMarginRate            = bitstype(c"struct CThostFtdcQryExchangeMarginRateField")
cCtpQryExchangeMarginRateAdjust      = bitstype(c"struct CThostFtdcQryExchangeMarginRateAdjustField")
cCtpQryExchangeRate                  = bitstype(c"struct CThostFtdcQryExchangeRateField")
cCtpQrySyncFundMortgage              = bitstype(c"struct CThostFtdcQrySyncFundMortgageField")
cCtpQryHisOrder                      = bitstype(c"struct CThostFtdcQryHisOrderField")
cCtpOptionInstrMiniMargin            = bitstype(c"struct CThostFtdcOptionInstrMiniMarginField")
cCtpOptionInstrMarginAdjust          = bitstype(c"struct CThostFtdcOptionInstrMarginAdjustField")
cCtpOptionInstrCommRate              = bitstype(c"struct CThostFtdcOptionInstrCommRateField")
cCtpOptionInstrTradeCost             = bitstype(c"struct CThostFtdcOptionInstrTradeCostField")
cCtpQryOptionInstrTradeCost          = bitstype(c"struct CThostFtdcQryOptionInstrTradeCostField")
cCtpQryOptionInstrCommRate           = bitstype(c"struct CThostFtdcQryOptionInstrCommRateField")
cCtpIndexPrice                       = bitstype(c"struct CThostFtdcIndexPriceField")
cCtpInputExecOrder                   = bitstype(c"struct CThostFtdcInputExecOrderField")
cCtpInputExecOrderAction             = bitstype(c"struct CThostFtdcInputExecOrderActionField")
cCtpExecOrder                        = bitstype(c"struct CThostFtdcExecOrderField")
cCtpExecOrderAction                  = bitstype(c"struct CThostFtdcExecOrderActionField")
cCtpQryExecOrder                     = bitstype(c"struct CThostFtdcQryExecOrderField")
cCtpExchangeExecOrder                = bitstype(c"struct CThostFtdcExchangeExecOrderField")
cCtpQryExchangeExecOrder             = bitstype(c"struct CThostFtdcQryExchangeExecOrderField")
cCtpQryExecOrderAction               = bitstype(c"struct CThostFtdcQryExecOrderActionField")
cCtpExchangeExecOrderAction          = bitstype(c"struct CThostFtdcExchangeExecOrderActionField")
cCtpQryExchangeExecOrderAction       = bitstype(c"struct CThostFtdcQryExchangeExecOrderActionField")
cCtpErrExecOrder                     = bitstype(c"struct CThostFtdcErrExecOrderField")
cCtpQryErrExecOrder                  = bitstype(c"struct CThostFtdcQryErrExecOrderField")
cCtpErrExecOrderAction               = bitstype(c"struct CThostFtdcErrExecOrderActionField")
cCtpQryErrExecOrderAction            = bitstype(c"struct CThostFtdcQryErrExecOrderActionField")
cCtpOptionInstrTradingRight          = bitstype(c"struct CThostFtdcOptionInstrTradingRightField")
cCtpQryOptionInstrTradingRight       = bitstype(c"struct CThostFtdcQryOptionInstrTradingRightField")
cCtpInputForQuote                    = bitstype(c"struct CThostFtdcInputForQuoteField")
cCtpForQuote                         = bitstype(c"struct CThostFtdcForQuoteField")
cCtpQryForQuote                      = bitstype(c"struct CThostFtdcQryForQuoteField")
cCtpExchangeForQuote                 = bitstype(c"struct CThostFtdcExchangeForQuoteField")
cCtpQryExchangeForQuote              = bitstype(c"struct CThostFtdcQryExchangeForQuoteField")
cCtpInputQuote                       = bitstype(c"struct CThostFtdcInputQuoteField")
cCtpInputQuoteAction                 = bitstype(c"struct CThostFtdcInputQuoteActionField")
cCtpQuote                            = bitstype(c"struct CThostFtdcQuoteField")
cCtpQuoteAction                      = bitstype(c"struct CThostFtdcQuoteActionField")
cCtpQryQuote                         = bitstype(c"struct CThostFtdcQryQuoteField")
cCtpExchangeQuote                    = bitstype(c"struct CThostFtdcExchangeQuoteField")
cCtpQryExchangeQuote                 = bitstype(c"struct CThostFtdcQryExchangeQuoteField")
cCtpQryQuoteAction                   = bitstype(c"struct CThostFtdcQryQuoteActionField")
cCtpExchangeQuoteAction              = bitstype(c"struct CThostFtdcExchangeQuoteActionField")
cCtpQryExchangeQuoteAction           = bitstype(c"struct CThostFtdcQryExchangeQuoteActionField")
cCtpOptionInstrDelta                 = bitstype(c"struct CThostFtdcOptionInstrDeltaField")
cCtpForQuoteRsp                      = bitstype(c"struct CThostFtdcForQuoteRspField")
cCtpStrikeOffset                     = bitstype(c"struct CThostFtdcStrikeOffsetField")
cCtpQryStrikeOffset                  = bitstype(c"struct CThostFtdcQryStrikeOffsetField")
cCtpInputBatchOrderAction            = bitstype(c"struct CThostFtdcInputBatchOrderActionField")
cCtpBatchOrderAction                 = bitstype(c"struct CThostFtdcBatchOrderActionField")
cCtpExchangeBatchOrderAction         = bitstype(c"struct CThostFtdcExchangeBatchOrderActionField")
cCtpQryBatchOrderAction              = bitstype(c"struct CThostFtdcQryBatchOrderActionField")
cCtpCombInstrumentGuard              = bitstype(c"struct CThostFtdcCombInstrumentGuardField")
cCtpQryCombInstrumentGuard           = bitstype(c"struct CThostFtdcQryCombInstrumentGuardField")
cCtpInputCombAction                  = bitstype(c"struct CThostFtdcInputCombActionField")
cCtpCombAction                       = bitstype(c"struct CThostFtdcCombActionField")
cCtpQryCombAction                    = bitstype(c"struct CThostFtdcQryCombActionField")
cCtpExchangeCombAction               = bitstype(c"struct CThostFtdcExchangeCombActionField")
cCtpQryExchangeCombAction            = bitstype(c"struct CThostFtdcQryExchangeCombActionField")
cCtpProductExchRate                  = bitstype(c"struct CThostFtdcProductExchRateField")
cCtpQryProductExchRate               = bitstype(c"struct CThostFtdcQryProductExchRateField")
cCtpQryForQuoteParam                 = bitstype(c"struct CThostFtdcQryForQuoteParamField")
cCtpForQuoteParam                    = bitstype(c"struct CThostFtdcForQuoteParamField")
cCtpMMOptionInstrCommRate            = bitstype(c"struct CThostFtdcMMOptionInstrCommRateField")
cCtpQryMMOptionInstrCommRate         = bitstype(c"struct CThostFtdcQryMMOptionInstrCommRateField")
cCtpMMInstrumentCommissionRate       = bitstype(c"struct CThostFtdcMMInstrumentCommissionRateField")
cCtpQryMMInstrumentCommissionRate    = bitstype(c"struct CThostFtdcQryMMInstrumentCommissionRateField")
cCtpInstrumentOrderCommRate          = bitstype(c"struct CThostFtdcInstrumentOrderCommRateField")
cCtpQryInstrumentOrderCommRate       = bitstype(c"struct CThostFtdcQryInstrumentOrderCommRateField")
cCtpTradeParam                       = bitstype(c"struct CThostFtdcTradeParamField")
cCtpInstrumentMarginRateUL           = bitstype(c"struct CThostFtdcInstrumentMarginRateULField")
cCtpFutureLimitPosiParam             = bitstype(c"struct CThostFtdcFutureLimitPosiParamField")
cCtpLoginForbiddenIP                 = bitstype(c"struct CThostFtdcLoginForbiddenIPField")
cCtpIPList                           = bitstype(c"struct CThostFtdcIPListField")
cCtpInputOptionSelfClose             = bitstype(c"struct CThostFtdcInputOptionSelfCloseField")
cCtpInputOptionSelfCloseAction       = bitstype(c"struct CThostFtdcInputOptionSelfCloseActionField")
cCtpOptionSelfClose                  = bitstype(c"struct CThostFtdcOptionSelfCloseField")
cCtpOptionSelfCloseAction            = bitstype(c"struct CThostFtdcOptionSelfCloseActionField")
cCtpQryOptionSelfClose               = bitstype(c"struct CThostFtdcQryOptionSelfCloseField")
cCtpExchangeOptionSelfClose          = bitstype(c"struct CThostFtdcExchangeOptionSelfCloseField")
cCtpQryOptionSelfCloseAction         = bitstype(c"struct CThostFtdcQryOptionSelfCloseActionField")
cCtpExchangeOptionSelfCloseAction    = bitstype(c"struct CThostFtdcExchangeOptionSelfCloseActionField")
cCtpSyncDelaySwap                    = bitstype(c"struct CThostFtdcSyncDelaySwapField")
cCtpQrySyncDelaySwap                 = bitstype(c"struct CThostFtdcQrySyncDelaySwapField")
cCtpInvestUnit                       = bitstype(c"struct CThostFtdcInvestUnitField")
cCtpQryInvestUnit                    = bitstype(c"struct CThostFtdcQryInvestUnitField")
cCtpSecAgentCheckMode                = bitstype(c"struct CThostFtdcSecAgentCheckModeField")
cCtpSecAgentTradeInfo                = bitstype(c"struct CThostFtdcSecAgentTradeInfoField")
cCtpMarketData                       = bitstype(c"struct CThostFtdcMarketDataField")
cCtpMarketDataBase                   = bitstype(c"struct CThostFtdcMarketDataBaseField")
cCtpMarketDataStatic                 = bitstype(c"struct CThostFtdcMarketDataStaticField")
cCtpMarketDataLastMatch              = bitstype(c"struct CThostFtdcMarketDataLastMatchField")
cCtpMarketDataBestPrice              = bitstype(c"struct CThostFtdcMarketDataBestPriceField")
cCtpMarketDataBid23                  = bitstype(c"struct CThostFtdcMarketDataBid23Field")
cCtpMarketDataAsk23                  = bitstype(c"struct CThostFtdcMarketDataAsk23Field")
cCtpMarketDataBid45                  = bitstype(c"struct CThostFtdcMarketDataBid45Field")
cCtpMarketDataAsk45                  = bitstype(c"struct CThostFtdcMarketDataAsk45Field")
cCtpMarketDataUpdateTime             = bitstype(c"struct CThostFtdcMarketDataUpdateTimeField")
cCtpMarketDataBandingPrice           = bitstype(c"struct CThostFtdcMarketDataBandingPriceField")
cCtpMarketDataExchange               = bitstype(c"struct CThostFtdcMarketDataExchangeField")
cCtpSpecificInstrument               = bitstype(c"struct CThostFtdcSpecificInstrumentField")
cCtpInstrumentStatus                 = bitstype(c"struct CThostFtdcInstrumentStatusField")
cCtpQryInstrumentStatus              = bitstype(c"struct CThostFtdcQryInstrumentStatusField")
cCtpInvestorAccount                  = bitstype(c"struct CThostFtdcInvestorAccountField")
cCtpPositionProfitAlgorithm          = bitstype(c"struct CThostFtdcPositionProfitAlgorithmField")
cCtpDiscount                         = bitstype(c"struct CThostFtdcDiscountField")
cCtpQryTransferBank                  = bitstype(c"struct CThostFtdcQryTransferBankField")
cCtpTransferBank                     = bitstype(c"struct CThostFtdcTransferBankField")
cCtpQryInvestorPositionDetail        = bitstype(c"struct CThostFtdcQryInvestorPositionDetailField")
cCtpInvestorPositionDetail           = bitstype(c"struct CThostFtdcInvestorPositionDetailField")
cCtpTradingAccountPassword           = bitstype(c"struct CThostFtdcTradingAccountPasswordField")
cCtpMDTraderOffer                    = bitstype(c"struct CThostFtdcMDTraderOfferField")
cCtpQryMDTraderOffer                 = bitstype(c"struct CThostFtdcQryMDTraderOfferField")
cCtpQryNotice                        = bitstype(c"struct CThostFtdcQryNoticeField")
cCtpNotice                           = bitstype(c"struct CThostFtdcNoticeField")
cCtpUserRight                        = bitstype(c"struct CThostFtdcUserRightField")
cCtpQrySettlementInfoConfirm         = bitstype(c"struct CThostFtdcQrySettlementInfoConfirmField")
cCtpLoadSettlementInfo               = bitstype(c"struct CThostFtdcLoadSettlementInfoField")
cCtpBrokerWithdrawAlgorithm          = bitstype(c"struct CThostFtdcBrokerWithdrawAlgorithmField")
cCtpTradingAccountPasswordUpdateV1   = bitstype(c"struct CThostFtdcTradingAccountPasswordUpdateV1Field")
cCtpTradingAccountPasswordUpdate     = bitstype(c"struct CThostFtdcTradingAccountPasswordUpdateField")
cCtpQryCombinationLeg                = bitstype(c"struct CThostFtdcQryCombinationLegField")
cCtpQrySyncStatus                    = bitstype(c"struct CThostFtdcQrySyncStatusField")
cCtpCombinationLeg                   = bitstype(c"struct CThostFtdcCombinationLegField")
cCtpSyncStatus                       = bitstype(c"struct CThostFtdcSyncStatusField")
cCtpQryLinkMan                       = bitstype(c"struct CThostFtdcQryLinkManField")
cCtpLinkMan                          = bitstype(c"struct CThostFtdcLinkManField")
cCtpQryBrokerUserEvent               = bitstype(c"struct CThostFtdcQryBrokerUserEventField")
cCtpBrokerUserEvent                  = bitstype(c"struct CThostFtdcBrokerUserEventField")
cCtpQryContractBank                  = bitstype(c"struct CThostFtdcQryContractBankField")
cCtpContractBank                     = bitstype(c"struct CThostFtdcContractBankField")
cCtpInvestorPositionCombineDetail    = bitstype(c"struct CThostFtdcInvestorPositionCombineDetailField")
cCtpParkedOrder                      = bitstype(c"struct CThostFtdcParkedOrderField")
cCtpParkedOrderAction                = bitstype(c"struct CThostFtdcParkedOrderActionField")
cCtpQryParkedOrder                   = bitstype(c"struct CThostFtdcQryParkedOrderField")
cCtpQryParkedOrderAction             = bitstype(c"struct CThostFtdcQryParkedOrderActionField")
cCtpRemoveParkedOrder                = bitstype(c"struct CThostFtdcRemoveParkedOrderField")
cCtpRemoveParkedOrderAction          = bitstype(c"struct CThostFtdcRemoveParkedOrderActionField")
cCtpInvestorWithdrawAlgorithm        = bitstype(c"struct CThostFtdcInvestorWithdrawAlgorithmField")
cCtpQryInvestorPositionCombineDetail = bitstype(c"struct CThostFtdcQryInvestorPositionCombineDetailField")
cCtpMarketDataAveragePrice           = bitstype(c"struct CThostFtdcMarketDataAveragePriceField")
cCtpVerifyInvestorPassword           = bitstype(c"struct CThostFtdcVerifyInvestorPasswordField")
cCtpUserIP                           = bitstype(c"struct CThostFtdcUserIPField")
cCtpTradingNoticeInfo                = bitstype(c"struct CThostFtdcTradingNoticeInfoField")
cCtpTradingNotice                    = bitstype(c"struct CThostFtdcTradingNoticeField")
cCtpQryTradingNotice                 = bitstype(c"struct CThostFtdcQryTradingNoticeField")
cCtpQryErrOrder                      = bitstype(c"struct CThostFtdcQryErrOrderField")
cCtpErrOrder                         = bitstype(c"struct CThostFtdcErrOrderField")
cCtpErrorConditionalOrder            = bitstype(c"struct CThostFtdcErrorConditionalOrderField")
cCtpQryErrOrderAction                = bitstype(c"struct CThostFtdcQryErrOrderActionField")
cCtpErrOrderAction                   = bitstype(c"struct CThostFtdcErrOrderActionField")
cCtpQryExchangeSequence              = bitstype(c"struct CThostFtdcQryExchangeSequenceField")
cCtpExchangeSequence                 = bitstype(c"struct CThostFtdcExchangeSequenceField")
cCtpQryMaxOrderVolumeWithPrice       = bitstype(c"struct CThostFtdcQryMaxOrderVolumeWithPriceField")
cCtpQryBrokerTradingParams           = bitstype(c"struct CThostFtdcQryBrokerTradingParamsField")
cCtpBrokerTradingParams              = bitstype(c"struct CThostFtdcBrokerTradingParamsField")
cCtpQryBrokerTradingAlgos            = bitstype(c"struct CThostFtdcQryBrokerTradingAlgosField")
cCtpBrokerTradingAlgos               = bitstype(c"struct CThostFtdcBrokerTradingAlgosField")
cCtpQueryBrokerDeposit               = bitstype(c"struct CThostFtdcQueryBrokerDepositField")
cCtpBrokerDeposit                    = bitstype(c"struct CThostFtdcBrokerDepositField")
cCtpQryCFMMCBrokerKey                = bitstype(c"struct CThostFtdcQryCFMMCBrokerKeyField")
cCtpCFMMCBrokerKey                   = bitstype(c"struct CThostFtdcCFMMCBrokerKeyField")
cCtpCFMMCTradingAccountKey           = bitstype(c"struct CThostFtdcCFMMCTradingAccountKeyField")
cCtpQryCFMMCTradingAccountKey        = bitstype(c"struct CThostFtdcQryCFMMCTradingAccountKeyField")
cCtpBrokerUserOTPParam               = bitstype(c"struct CThostFtdcBrokerUserOTPParamField")
cCtpManualSyncBrokerUserOTP          = bitstype(c"struct CThostFtdcManualSyncBrokerUserOTPField")
cCtpCommRateModel                    = bitstype(c"struct CThostFtdcCommRateModelField")
cCtpQryCommRateModel                 = bitstype(c"struct CThostFtdcQryCommRateModelField")
cCtpMarginModel                      = bitstype(c"struct CThostFtdcMarginModelField")
cCtpQryMarginModel                   = bitstype(c"struct CThostFtdcQryMarginModelField")
cCtpEWarrantOffset                   = bitstype(c"struct CThostFtdcEWarrantOffsetField")
cCtpQryEWarrantOffset                = bitstype(c"struct CThostFtdcQryEWarrantOffsetField")
cCtpQryInvestorProductGroupMargin    = bitstype(c"struct CThostFtdcQryInvestorProductGroupMarginField")
cCtpInvestorProductGroupMargin       = bitstype(c"struct CThostFtdcInvestorProductGroupMarginField")
cCtpQueryCFMMCTradingAccountToken    = bitstype(c"struct CThostFtdcQueryCFMMCTradingAccountTokenField")
cCtpCFMMCTradingAccountToken         = bitstype(c"struct CThostFtdcCFMMCTradingAccountTokenField")
cCtpQryProductGroup                  = bitstype(c"struct CThostFtdcQryProductGroupField")
cCtpProductGroup                     = bitstype(c"struct CThostFtdcProductGroupField")
cCtpBulletin                         = bitstype(c"struct CThostFtdcBulletinField")
cCtpQryBulletin                      = bitstype(c"struct CThostFtdcQryBulletinField")
cCtpMulticastInstrument              = bitstype(c"struct CThostFtdcMulticastInstrumentField")
cCtpQryMulticastInstrument           = bitstype(c"struct CThostFtdcQryMulticastInstrumentField")
cCtpAppIDAuthAssign                  = bitstype(c"struct CThostFtdcAppIDAuthAssignField")
cCtpReqOpenAccount                   = bitstype(c"struct CThostFtdcReqOpenAccountField")
cCtpReqCancelAccount                 = bitstype(c"struct CThostFtdcReqCancelAccountField")
cCtpReqChangeAccount                 = bitstype(c"struct CThostFtdcReqChangeAccountField")
cCtpReqTransfer                      = bitstype(c"struct CThostFtdcReqTransferField")
cCtpRspTransfer                      = bitstype(c"struct CThostFtdcRspTransferField")
cCtpReqRepeal                        = bitstype(c"struct CThostFtdcReqRepealField")
cCtpRspRepeal                        = bitstype(c"struct CThostFtdcRspRepealField")
cCtpReqQueryAccount                  = bitstype(c"struct CThostFtdcReqQueryAccountField")
cCtpRspQueryAccount                  = bitstype(c"struct CThostFtdcRspQueryAccountField")
cCtpFutureSignIO                     = bitstype(c"struct CThostFtdcFutureSignIOField")
cCtpRspFutureSignIn                  = bitstype(c"struct CThostFtdcRspFutureSignInField")
cCtpReqFutureSignOut                 = bitstype(c"struct CThostFtdcReqFutureSignOutField")
cCtpRspFutureSignOut                 = bitstype(c"struct CThostFtdcRspFutureSignOutField")
cCtpReqQueryTradeResultBySerial      = bitstype(c"struct CThostFtdcReqQueryTradeResultBySerialField")
cCtpRspQueryTradeResultBySerial      = bitstype(c"struct CThostFtdcRspQueryTradeResultBySerialField")
cCtpReqDayEndFileReady               = bitstype(c"struct CThostFtdcReqDayEndFileReadyField")
cCtpReturnResult                     = bitstype(c"struct CThostFtdcReturnResultField")
cCtpVerifyFuturePassword             = bitstype(c"struct CThostFtdcVerifyFuturePasswordField")
cCtpVerifyCustInfo                   = bitstype(c"struct CThostFtdcVerifyCustInfoField")
cCtpVerifyFuturePasswordAndCustInfo  = bitstype(c"struct CThostFtdcVerifyFuturePasswordAndCustInfoField")
cCtpDepositResultInform              = bitstype(c"struct CThostFtdcDepositResultInformField")
cCtpReqSyncKey                       = bitstype(c"struct CThostFtdcReqSyncKeyField")
cCtpRspSyncKey                       = bitstype(c"struct CThostFtdcRspSyncKeyField")
cCtpNotifyQueryAccount               = bitstype(c"struct CThostFtdcNotifyQueryAccountField")
cCtpTransferSerial                   = bitstype(c"struct CThostFtdcTransferSerialField")
cCtpQryTransferSerial                = bitstype(c"struct CThostFtdcQryTransferSerialField")
cCtpNotifyFutureSignIn               = bitstype(c"struct CThostFtdcNotifyFutureSignInField")
cCtpNotifyFutureSignOut              = bitstype(c"struct CThostFtdcNotifyFutureSignOutField")
cCtpNotifySyncKey                    = bitstype(c"struct CThostFtdcNotifySyncKeyField")
cCtpQryAccountregister               = bitstype(c"struct CThostFtdcQryAccountregisterField")
cCtpAccountregister                  = bitstype(c"struct CThostFtdcAccountregisterField")
cCtpOpenAccount                      = bitstype(c"struct CThostFtdcOpenAccountField")
cCtpCancelAccount                    = bitstype(c"struct CThostFtdcCancelAccountField")
cCtpChangeAccount                    = bitstype(c"struct CThostFtdcChangeAccountField")
cCtpSecAgentACIDMap                  = bitstype(c"struct CThostFtdcSecAgentACIDMapField")
cCtpQrySecAgentACIDMap               = bitstype(c"struct CThostFtdcQrySecAgentACIDMapField")
cCtpUserRightsAssign                 = bitstype(c"struct CThostFtdcUserRightsAssignField")
cCtpBrokerUserRightAssign            = bitstype(c"struct CThostFtdcBrokerUserRightAssignField")
cCtpDRTransfer                       = bitstype(c"struct CThostFtdcDRTransferField")
cCtpFensUserInfo                     = bitstype(c"struct CThostFtdcFensUserInfoField")
cCtpCurrTransferIdentity             = bitstype(c"struct CThostFtdcCurrTransferIdentityField")
cCtpLoginForbiddenUser               = bitstype(c"struct CThostFtdcLoginForbiddenUserField")
cCtpQryLoginForbiddenUser            = bitstype(c"struct CThostFtdcQryLoginForbiddenUserField")
cCtpTradingAccountReserve            = bitstype(c"struct CThostFtdcTradingAccountReserveField")
cCtpQryLoginForbiddenIP              = bitstype(c"struct CThostFtdcQryLoginForbiddenIPField")
cCtpQryIPList                        = bitstype(c"struct CThostFtdcQryIPListField")
cCtpQryUserRightsAssign              = bitstype(c"struct CThostFtdcQryUserRightsAssignField")
cCtpReserveOpenAccountConfirm        = bitstype(c"struct CThostFtdcReserveOpenAccountConfirmField")
cCtpReserveOpenAccount               = bitstype(c"struct CThostFtdcReserveOpenAccountField")
cCtpAccountProperty                  = bitstype(c"struct CThostFtdcAccountPropertyField")
cCtpQryCurrDRIdentity                = bitstype(c"struct CThostFtdcQryCurrDRIdentityField")
cCtpCurrDRIdentity                   = bitstype(c"struct CThostFtdcCurrDRIdentityField")
cCtpQrySecAgentCheckMode             = bitstype(c"struct CThostFtdcQrySecAgentCheckModeField")
cCtpQrySecAgentTradeInfo             = bitstype(c"struct CThostFtdcQrySecAgentTradeInfoField")
cCtpReqUserAuthMethod                = bitstype(c"struct CThostFtdcReqUserAuthMethodField")
cCtpRspUserAuthMethod                = bitstype(c"struct CThostFtdcRspUserAuthMethodField")
cCtpReqGenUserCaptcha                = bitstype(c"struct CThostFtdcReqGenUserCaptchaField")
cCtpRspGenUserCaptcha                = bitstype(c"struct CThostFtdcRspGenUserCaptchaField")
cCtpReqGenUserText                   = bitstype(c"struct CThostFtdcReqGenUserTextField")
cCtpRspGenUserText                   = bitstype(c"struct CThostFtdcRspGenUserTextField")
cCtpReqUserLoginWithCaptcha          = bitstype(c"struct CThostFtdcReqUserLoginWithCaptchaField")
cCtpReqUserLoginWithText             = bitstype(c"struct CThostFtdcReqUserLoginWithTextField")
cCtpReqUserLoginWithOTP              = bitstype(c"struct CThostFtdcReqUserLoginWithOTPField")
cCtpReqApiHandshake                  = bitstype(c"struct CThostFtdcReqApiHandshakeField")
cCtpRspApiHandshake                  = bitstype(c"struct CThostFtdcRspApiHandshakeField")
cCtpReqVerifyApiKey                  = bitstype(c"struct CThostFtdcReqVerifyApiKeyField")
cCtpDepartmentUser                   = bitstype(c"struct CThostFtdcDepartmentUserField")
cCtpQueryFreq                        = bitstype(c"struct CThostFtdcQueryFreqField")
cCtpAuthForbiddenIP                  = bitstype(c"struct CThostFtdcAuthForbiddenIPField")
cCtpQryAuthForbiddenIP               = bitstype(c"struct CThostFtdcQryAuthForbiddenIPField")
cCtpSyncDelaySwapFrozen              = bitstype(c"struct CThostFtdcSyncDelaySwapFrozenField")
cCtpUserSystemInfo                   = bitstype(c"struct CThostFtdcUserSystemInfoField")
cCtpAuthUserID                       = bitstype(c"struct CThostFtdcAuthUserIDField")
cCtpAuthIP                           = bitstype(c"struct CThostFtdcAuthIPField")
cCtpQryClassifiedInstrument          = bitstype(c"struct CThostFtdcQryClassifiedInstrumentField")
cCtpQryCombPromotionParam            = bitstype(c"struct CThostFtdcQryCombPromotionParamField")
cCtpCombPromotionParam               = bitstype(c"struct CThostFtdcCombPromotionParamField")
cCtpQryRiskSettleInvstPosition       = bitstype(c"struct CThostFtdcQryRiskSettleInvstPositionField")
cCtpQryRiskSettleProductStatus       = bitstype(c"struct CThostFtdcQryRiskSettleProductStatusField")
cCtpRiskSettleInvstPosition          = bitstype(c"struct CThostFtdcRiskSettleInvstPositionField")
cCtpRiskSettleProductStatus          = bitstype(c"struct CThostFtdcRiskSettleProductStatusField")
cCtpSyncDeltaInfo                    = bitstype(c"struct CThostFtdcSyncDeltaInfoField")
cCtpSyncDeltaProductStatus           = bitstype(c"struct CThostFtdcSyncDeltaProductStatusField")
cCtpSyncDeltaInvstPosDtl             = bitstype(c"struct CThostFtdcSyncDeltaInvstPosDtlField")
cCtpSyncDeltaInvstPosCombDtl         = bitstype(c"struct CThostFtdcSyncDeltaInvstPosCombDtlField")
cCtpSyncDeltaTradingAccount          = bitstype(c"struct CThostFtdcSyncDeltaTradingAccountField")
cCtpSyncDeltaInitInvstMargin         = bitstype(c"struct CThostFtdcSyncDeltaInitInvstMarginField")
cCtpSyncDeltaDceCombInstrument       = bitstype(c"struct CThostFtdcSyncDeltaDceCombInstrumentField")
cCtpSyncDeltaInvstMarginRate         = bitstype(c"struct CThostFtdcSyncDeltaInvstMarginRateField")
cCtpSyncDeltaExchMarginRate          = bitstype(c"struct CThostFtdcSyncDeltaExchMarginRateField")
cCtpSyncDeltaOptExchMargin           = bitstype(c"struct CThostFtdcSyncDeltaOptExchMarginField")
cCtpSyncDeltaOptInvstMargin          = bitstype(c"struct CThostFtdcSyncDeltaOptInvstMarginField")
cCtpSyncDeltaInvstMarginRateUL       = bitstype(c"struct CThostFtdcSyncDeltaInvstMarginRateULField")
cCtpSyncDeltaOptInvstCommRate        = bitstype(c"struct CThostFtdcSyncDeltaOptInvstCommRateField")
cCtpSyncDeltaInvstCommRate           = bitstype(c"struct CThostFtdcSyncDeltaInvstCommRateField")
cCtpSyncDeltaProductExchRate         = bitstype(c"struct CThostFtdcSyncDeltaProductExchRateField")
cCtpSyncDeltaDepthMarketData         = bitstype(c"struct CThostFtdcSyncDeltaDepthMarketDataField")
cCtpSyncDeltaIndexPrice              = bitstype(c"struct CThostFtdcSyncDeltaIndexPriceField")
cCtpSyncDeltaEWarrantOffset          = bitstype(c"struct CThostFtdcSyncDeltaEWarrantOffsetField")


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
