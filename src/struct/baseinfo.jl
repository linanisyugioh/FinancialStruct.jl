c";
#pragma pack(push, 1)
typedef struct t_SHProductInfo_HDB{
   char ISIN[12];
   char UpdateTime[8];
   char Symbol[32];
   char EnglishName[10];
   char UnderlyingSecurityID[6];
   char MarketType[4];
   char SecurityType[6];
   char SecuritySubType[3];
   char Currency[3];
   uint64_t ParValue;
   uint64_t UnlistedFloatShareQuantity;
   uint32_t LastTradeDate;
   uint32_t ListDate;
   uint32_t SETNo;
   uint64_t BuyQtyUnit;
   uint64_t SellQtyUnit;
   uint64_t QtyLowerLimit;
   uint64_t QtyUpperLimit;
   uint64_t PrevClosePx;
   uint64_t PriceTick;
   char LimitType;
   uint64_t LimitUpAbsolute;
   uint64_t LimitDownAbsolute;
   uint64_t XR;
   uint64_t XD;
   char CrdBuyUnderlying;
   char CrdSellUnderlying;
   char Status[20];
   uint64_t MarketQtyLowerLimit;
   uint64_t MarketQtyUpperLimit;
   char ChineseName[128];
   char MEMO[400];
}SHProductInfo_HDB;

typedef struct t_SHOptionInfo_HDB{
   char RFStreamID[5];
   char ContractID[41];
   char ContractSymbol[80];
   char UnderlyingSecurityID[6];
   char UnderlyingSecuritySymbol[32];
   char UnderlyingType[3];
   char OptionType;
   char CallOrPut;
   uint64_t ContractMultiplierUnit;
   uint64_t ExercisePrice;
   uint32_t StartDate;
   uint32_t EndDate;
   uint32_t ExerciseDate;
   uint32_t DeliveryDate;
   uint32_t ExpireDate;
   char UpdateVersion;
   uint64_t TotalLongPosition;
   uint64_t SecurityClosePx;
   uint64_t SettlPrice;
   uint64_t UnderlyingPreClosePx;
   char PriceLimitType;
   uint64_t DailyPriceUpLimit;
   uint64_t DailyPriceDownLimit;
   uint64_t MarginUnit;
   uint64_t MarginRatioParam1;
   uint64_t MarginRatioParam2;
   uint64_t RoundLot;
   uint64_t LmtOrdMinFloor;
   uint64_t LmtOrdMaxFloor;
   uint64_t MktOrdMinFloor;
   uint64_t MktOrdMaxFloor;
   uint64_t TickSize;
   char SecurityStatusFlag[8];
   uint32_t AutoSplitDate;
   char UnderlyingSymbolEx[40];
}SHOptionInfo_HDB;

typedef struct t_SZPStock_HDB{
   char SecurityIDSource[4];
   char Symbol[160];
   char SymbolEx[160];
   char EnglishName[40];
   char ISIN[12];
   char UnderlyingSecurityID[8];
   char UnderlyingSecurityIDSource[4];
   uint64_t ListDate;
   uint32_t SecurityType;
   char Currency[4];
   uint64_t QtyUnit;
   char DayTrading;
   uint64_t PrevClosePx;
   uint32_t SecurityStatus[13];
   uint64_t OutstandingShare;
   uint64_t PublicFloatShareQuantity;
   uint64_t ParValue;
   char GageFlag;
   uint64_t GageRatio;
   char CrdBuyUnderlying;
   char CrdSellUnderlying;
   int32_t PriceCheckMode;
   char PledgeFlag;
   uint64_t ContractMultiplier;
   char RegularShare[8];
   char QualificationFalg;
   uint32_t QualificationClass;
   uint64_t Interest;
   char OfferingFlag;
}SZPStock_HDB;

typedef struct t_SZStock_HDB{
   char SecurityIDSource[4];
   char Symbol[160];
   char SymbolEx[160];
   char EnglishName[40];
   char ISIN[12];
   char UnderlyingSecurityID[8];
   char UnderlyingSecurityIDSource[4];
   uint64_t ListDate;
   uint32_t SecurityType;
   char Currency[4];
   uint64_t QtyUnit;
   char DayTrading;
   uint64_t PrevClosePx;
   uint32_t SecurityStatus[13];
   uint64_t OutstandingShare;
   uint64_t PublicFloatShareQuantity;
   uint64_t ParValue;
   char GageFlag;
   uint64_t GageRatio;
   char CrdBuyUnderlying;
   char CrdSellUnderlying;
   int32_t PriceCheckMode;
   char PledgeFlag;
   uint64_t ContractMultiplier;
   char RegularShare[8];
   char QualificationFalg;
   uint32_t QualificationClass;
   char IndustryClassification[4];
   uint64_t PreviousYearProfitPerShare;
   uint64_t CurrentYearProfitPerShare;
   char OfferingFlag;
   int32_t Attribute;
   char NoProfit;
   char WeightedVotingRights;
   char IsRegistration;
   char IsVIE;
}SZStock_HDB;

typedef struct t_SZFund_HDB{
   char SecurityIDSource[4];
   char Symbol[160];
   char SymbolEx[160];
   char EnglishName[40];
   char ISIN[12];
   char UnderlyingSecurityID[8];
   char UnderlyingSecurityIDSource[4];
   uint64_t ListDate;
   uint32_t SecurityType;
   char Currency[4];
   uint64_t QtyUnit;
   char DayTrading;
   uint64_t PrevClosePx;
   uint32_t SecurityStatus[13];
   uint64_t OutstandingShare;
   uint64_t PublicFloatShareQuantity;
   uint64_t ParValue;
   char GageFlag;
   uint64_t GageRatio;
   char CrdBuyUnderlying;
   char CrdSellUnderlying;
   int32_t PriceCheckMode;
   char PledgeFlag;
   uint64_t ContractMultiplier;
   char RegularShare[8];
   char QualificationFalg;
   uint32_t QualificationClass;
   uint64_t NAV;
}SZFund_HDB;

typedef struct t_SZBond_HDB{
   char SecurityIDSource[4];
   char Symbol[160];
   char SymbolEx[160];
   char EnglishName[40];
   char ISIN[12];
   char UnderlyingSecurityID[8];
   char UnderlyingSecurityIDSource[4];
   uint64_t ListDate;
   uint32_t SecurityType;
   char Currency[4];
   uint64_t QtyUnit;
   char DayTrading;
   uint64_t PrevClosePx;
   uint32_t SecurityStatus[13];
   uint64_t OutstandingShare;
   uint64_t PublicFloatShareQuantity;
   uint64_t ParValue;
   char GageFlag;
   uint64_t GageRatio;
   char CrdBuyUnderlying;
   char CrdSellUnderlying;
   int32_t PriceCheckMode;
   char PledgeFlag;
   uint64_t ContractMultiplier;
   char RegularShare[8];
   char QualificationFalg;
   uint32_t QualificationClass;
   uint64_t CouponRate;
   uint64_t IssuePrice;
   uint64_t Interest;
   uint32_t InterestAccrualDate;
   uint32_t MaturityDate;
   char OfferingFlag;
   char SwapFlag;
   char PutbackFlag;
   char PutbackCancelFlag;
}SZBond_HDB;

typedef struct t_SZWarrant_HDB{
   char SecurityIDSource[4];
   char Symbol[160];
   char SymbolEx[160];
   char EnglishName[40];
   char ISIN[12];
   char UnderlyingSecurityID[8];
   char UnderlyingSecurityIDSource[4];
   uint64_t ListDate;
   uint32_t SecurityType;
   char Currency[4];
   uint64_t QtyUnit;
   char DayTrading;
   uint64_t PrevClosePx;
   uint32_t SecurityStatus[13];
   uint64_t OutstandingShare;
   uint64_t PublicFloatShareQuantity;
   uint64_t ParValue;
   char GageFlag;
   uint64_t GageRatio;
   char CrdBuyUnderlying;
   char CrdSellUnderlying;
   int32_t PriceCheckMode;
   char PledgeFlag;
   uint64_t ContractMultiplier;
   char RegularShare[8];
   char QualificationFalg;
   uint32_t QualificationClass;
   uint64_t ExercisePrice;
   uint64_t ExerciseRatio;
   uint32_t ExerciesBeginDate;
   uint32_t ExerciesEndDate;
   char CallOrPut;
   char DeliveryType;
   uint64_t ClearingPrice;
   char ExerciseType;
   uint32_t LastTradeDay;
}SZWarrant_HDB;

typedef struct t_SZRepo_HDB{
   char SecurityIDSource[4];
   char Symbol[160];
   char SymbolEx[160];
   char EnglishName[40];
   char ISIN[12];
   char UnderlyingSecurityID[8];
   char UnderlyingSecurityIDSource[4];
   uint64_t ListDate;
   uint32_t SecurityType;
   char Currency[4];
   uint64_t QtyUnit;
   char DayTrading;
   uint64_t PrevClosePx;
   uint32_t SecurityStatus[13];
   uint64_t OutstandingShare;
   uint64_t PublicFloatShareQuantity;
   uint64_t ParValue;
   char GageFlag;
   uint64_t GageRatio;
   char CrdBuyUnderlying;
   char CrdSellUnderlying;
   int32_t PriceCheckMode;
   char PledgeFlag;
   uint64_t ContractMultiplier;
   char RegularShare[8];
   char QualificationFalg;
   uint32_t QualificationClass;
   uint32_t ExpirationDays;
}SZRepo_HDB;

typedef struct t_SZOption_HDB{
   char SecurityIDSource[4];
   char Symbol[160];
   char SymbolEx[160];
   char EnglishName[40];
   char ISIN[12];
   char UnderlyingSecurityID[8];
   char UnderlyingSecurityIDSource[4];
   uint64_t ListDate;
   uint32_t SecurityType;
   char Currency[4];
   uint64_t QtyUnit;
   char DayTrading;
   uint64_t PrevClosePx;
   uint32_t SecurityStatus[13];
   uint64_t OutstandingShare;
   uint64_t PublicFloatShareQuantity;
   uint64_t ParValue;
   char GageFlag;
   uint64_t GageRatio;
   char CrdBuyUnderlying;
   char CrdSellUnderlying;
   int32_t PriceCheckMode;
   char PledgeFlag;
   uint64_t ContractMultiplier;
   char RegularShare[8];
   char QualificationFalg;
   uint32_t QualificationClass;
   char CallOrPut;
   uint32_t ListType;
   uint32_t DeliveryDay;
   uint32_t DeliveryMonth;
   char DeliveryType;
   uint32_t ExerciesBeginDate;
   uint32_t ExerciesEndDate;
   uint64_t ExercisePrice;
   char ExerciseType;
   uint32_t LastTradeDay;
   uint32_t AdjustTimes;
   uint64_t ContractUnit;
   uint64_t PrevClearingPrice;
   uint64_t ContractPosition;
}SZOption_HDB;

typedef struct t_SZReits_HDB{
   char SecurityIDSource[4];
   char Symbol[160];
   char SymbolEx[160];
   char EnglishName[40];
   char ISIN[12];
   char UnderlyingSecurityID[8];
   char UnderlyingSecurityIDSource[4];
   uint64_t ListDate;
   uint32_t SecurityType;
   char Currency[4];
   uint64_t QtyUnit;
   char DayTrading;
   uint64_t PrevClosePx;
   uint32_t SecurityStatus[13];
   uint64_t OutstandingShare;
   uint64_t PublicFloatShareQuantity;
   uint64_t ParValue;
   char GageFlag;
   uint64_t GageRatio;
   char CrdBuyUnderlying;
   char CrdSellUnderlying;
   int32_t PriceCheckMode;
   char PledgeFlag;
   uint64_t ContractMultiplier;
   char RegularShare[8];
   char QualificationFalg;
   uint32_t QualificationClass;
   uint32_t MaturityDate;
}SZReits_HDB;

typedef struct t_SZTenderer_HDB{
   char TendererID[6];
   char TendererName[200];
   uint64_t OfferingPrice;
   uint32_t BeginDate;
   uint32_t EndDate;
}SZTenderer_HDB;

typedef struct t_RightsIssue_HDB{
   char SecurityIDSource[4];
   char Symbol[160];
   char SymbolEx[160];
   char EnglishName[40];
   char UnderlyingSecurityID[8];
   char UnderlyingSecurityIDSource[4];
   uint64_t Price;
   uint64_t Unit;
}RightsIssue_HDB;

typedef struct t_DerivativeAuction_HDB{
   char SecurityIDSource[4];
   uint64_t BuyQtyUpperLimit;
   uint64_t SellQtyUpperLimit;
   uint64_t MarketBuyQtyUpperLimit;
   uint64_t MarketSellQtyUpperLimit;
   uint64_t QuoteBuyQtyUpperLimit;
   uint64_t QuoteSellQtyUpperLimit;
   uint64_t BuyQtyUnit;
   uint64_t SellQtyUnit;
   uint64_t PriceTick;
   uint64_t PriceUpperLimit;
   uint64_t PriceLowerLimit;
   uint64_t LastSellMargin;
   uint64_t SellMargin;
   uint64_t MarginRatioParam1;
   uint64_t MarginRatioParam2;
   char MarketMakerFlag;
}DerivativeAuction_HDB;

typedef struct t_CashAuction_HDB{
   char SecurityIDSource[4];
   uint64_t BuyQtyUpperLimit;
   uint64_t SellQtyUpperLimit;
   uint64_t BuyQtyUnit;
   uint64_t SellQtyUnit;
   uint64_t MarketBuyQtyUpperLimit;
   uint64_t MarketSellQtyUpperLimit;
   uint64_t MarketBuyQtyUnit;
   uint64_t MarketSellQtyUnit;
   uint64_t PriceTick;
   char MarketMakerFlag;
}CashAuction_HDB;

typedef struct t_PriceLimitSetting_HDB{
   char Type;
   char HasPriceLimit;
   char ReferPriceType;
   char LimitType;
   uint64_t LimitUpRate;
   uint64_t LimitDownRate;
   uint64_t LimitUpAbsolute;
   uint64_t LimitDownAbsolute;
   char HasAuctionLimit;
   char AuctionLimitType;
   char AuctionReferPriceType;
   uint64_t AuctionUpDownRate;
   uint64_t AuctionUpDownAbsolute;
}PriceLimitSetting_HDB;

typedef struct t_SZCombinationStrategy_HDB{
   char StrategyID[8];
   uint32_t AutoSplitDay;
}SZCombinationStrategy_HDB;

typedef struct t_TInstrument_HDB{
   char InstrumentName[40];
   uint64_t UpLimitPrice;
   uint64_t LowLimitPrice;
   int64_t VolumeMultiple;
   int64_t PriceTick;
   uint32_t OpenDate;
   uint32_t ExpireDate;
   char ExchangeID[9];
   int64_t LongMarginRatio;
   int64_t ShortMarginRatio;
}TInstrument_HDB;

typedef struct t_BJNQXX_HDB{
   char ShortName[16];
   char EnglishName[20];
   char BaseCode[6];
   char ISINCode[12];
   int32_t TradeUnit;
   char Industry[5];
   char Currency[2];
   int64_t ShareVal;
   int64_t Capital;
   int64_t NonRestCap;
   int64_t LastYearProfit;
   int64_t CurYearProfit;
   int64_t HandlingRate;
   int64_t StampDutyRate;
   int64_t TransferRate;
   uint32_t ListDate;
   uint32_t StartDate;
   uint32_t EndDate;
   int64_t MaxNumber;
   int32_t BuyNumber;
   int32_t SellNumber;
   int64_t MinNumber;
   int64_t PriceTick;
   int64_t FirstLimintParam;
   int64_t FollowLimitParam;
   int32_t LimitParamKind;
   int64_t HighLimitPrc;
   int64_t LowLimitPrc;
   int64_t BlockHighLimit;
   int64_t BlockLowLimit;
   char CompoFlag;
   int32_t EquiRatio;
   char TradeStatus;
   char SecLevel;
   char TradeType;
   int32_t MarketMakerNum;
   char HaltFlag;
   char QxFlag;
   char NetVoteFlag;
   char OtherBusStatus[4];
   int32_t UpdateTime;
}BJNQXX_HDB;

typedef struct t_SecurityInfo_HDB{
   char ISIN_CODE[40];
   char EXCHMARKET_CODE[40];
   char EXCHMARKET_ANN_CODE[40];
   char INFO_NAME_NATIONAL[40];
   char INFO_FULLNAME[300];
   char INFO_FULLNAME_ENG[200];
   uint32_t SECURITYCLASS;
   uint32_t SECURITYSUBCLASS;
   char SECURITYTYPE[10];
   char INFO_COUNTRYCODE[10];
   char INFO_EXCHANGE_ENG[40];
   char INFO_EXCHANGE[40];
   char INFO_CODE[10];
   char INFO_COMPCODE[10];
   char SECURITY_STATUS;
   char CRNCY_CODE[10];
   double INFO_CURPAR;
   double MIN_PRC_CHG_UNIT;
   double INFO_UNITPERLOT;
   char INFO_LISTDATE[8];
   char INFO_DELISTDATE[8];
   double INFO_LISTPRICE;
   uint32_t INFO_TYPECODE;
   char CONTRACT_ID[10];
   char INFO_LISTBOARDNAME[10];
   uint32_t TRADING_STATUS;
}SecurityInfo_HDB;

#pragma pack(pop)"
SHProductInfo = c"struct t_SHProductInfo_HDB"
SHOptionInfo = c"struct t_SHOptionInfo_HDB"
SZPStock = c"struct t_SZPStock_HDB"
SZStock = c"struct t_SZStock_HDB"
SZFund = c"struct t_SZFund_HDB"
SZBond = c"struct t_SZBond_HDB"
SZWarrant = c"struct t_SZWarrant_HDB"
SZRepo = c"struct t_SZRepo_HDB"
SZOption = c"struct t_SZOption_HDB"
SZReits = c"struct t_SZReits_HDB"
SZTenderer = c"struct t_SZTenderer_HDB"
RightsIssue = c"struct t_RightsIssue_HDB"
DerivativeAuction = c"struct t_DerivativeAuction_HDB"
CashAuction = c"struct t_CashAuction_HDB"
PriceLimitSetting = c"struct t_PriceLimitSetting_HDB"
SZCombinationStrategy = c"struct t_SZCombinationStrategy_HDB"
TInstrument = c"struct t_TInstrument_HDB"
BJNQXX = c"struct t_BJNQXX_HDB"
SecurityInfo = c"struct t_SecurityInfo_HDB"
baseinfo = (SHProductInfo, SHOptionInfo, SZPStock, SZStock, SZFund, SZBond, SZWarrant, SZRepo, SZOption, SZReits, SZTenderer, RightsIssue, DerivativeAuction, CashAuction, PriceLimitSetting, SZCombinationStrategy, TInstrument, BJNQXX, SecurityInfo, )
