/**
 * @file    trade_def.h
 * @brief   hftsdk 交易相关数据结构定义
 * @Copyright (c) 2022 上海紫虚科技有限公司
 */

#ifndef HFT_SDK_TRADE_DEF_H__
#define HFT_SDK_TRADE_DEF_H__

#include <stdint.h>

/**
 * 市场类型名字，与行情保持一致
 */
#define MARKET_SH "SH";        // 上海交易所
#define MARKET_SZ "SZ";        // 深圳交易所
#define MARKET_CFFEX "CFFEX";  // 中金所
#define MARKET_CZCE "CZCE";    // 郑商所
#define MARKET_DCE "DCE";      // 大商所
#define MARKET_SHFE "SHFE";    // 上期所
#define MARKET_HK "HK";        // 香港交易所
#define MARKET_SGE "SGE";      // 金交所
#define MARKET_CFETS "CFETS";  // 外汇交易中心
#define MARKET_SHOP "SHOP";    // 上海交易所期权
#define MARKET_SZOP "SZOP";    // 深圳交易所期权

// 字符字段长度定义
#define LEN_ID (32)
#define LEN_SYMBOL (32)
#define LEN_MARKET_ID (8)
#define LEN_CURRENCY (8)
#define LEN_COM_ID (32)
#define LEN_HEDGE_FLAG (8)
#define LEN_PLATE (4)
#define LEN_ERR_MSG (128)
#define LEN_ACCOUNT_ID (64)
#define LEN_EXT_INFO (128)

/**
 * 订单状态定义
 */
enum OrderStatus {
  OrderStatus_PendingNew = 1,         // 订单待报
  OrderStatus_New = 2,                // 订单已报
  OrderStatus_PartiallyFilled = 3,    // 订单部分成交
  OrderStatus_Filled = 4,             // 订单全部成交
  OrderStatus_PendingCancel = 5,      // 撤单待报
  OrderStatus_Canceling = 6,          // 已报待撤
  OrderStatus_CancelFilled = 7,       // 订单已撤销
  OrderStatus_PartiallyCanceled = 8,  // 部成部撤
  OrderStatus_Rejected = 9,           // 订单已拒绝
};

/**
 * 订单类型定义
 */
enum OrderType {
  OrderType_LMT = 1,    // 限价委托
  OrderType_BOC = 2,    // 对手方最优价格，深圳证券交易所
  OrderType_BOP = 3,    // 本方最优价格，深圳证券交易所
  OrderType_B5TC = 4,   // 最优五档剩余转撤销，上海/深圳证券交易所
  OrderType_B5TL = 5,   // 最优五档剩余转限价，上海证券交易所
  OrderType_IOC = 6,    // 即时成交剩余转撤销，深圳证券交易所
  OrderType_AON = 7,    // 全额成交或撤销，深圳证券交易所
  OrderType_ALMT = 9,   // 竞价限价，香港证券交易所
  OrderType_ELMT = 10,  // 增强限价，香港证券交易所
  OrderType_OLMT = 11,  // 零股限价，香港证券交易所
};

/**
 * 买卖方向定义
 */
enum OrderSide {
  OrderSide_Bid = 1,                     // 证券、基金、债券普通买入
  OrderSide_Ask = 2,                     // 证券、基金、债券普通卖出
  OrderSide_Long_Open = 3,               // 期货、期权多头开仓
  OrderSide_Long_Close = 4,              // 期货、期权多头平仓
  OrderSide_Short_Open = 5,              // 期货、期权空头开仓
  OrderSide_Short_Close = 6,             // 期货、期权空头平仓
  OrderSide_Today_Long_Close = 8,        // 上期所期货今仓多头平仓
  OrderSide_Today_Short_Close = 10,      // 上期所期货今仓空头平仓
  OrderSide_PreDay_Long_Close = 11,      // 上期所期货昨仓多头平仓
  OrderSide_PreDay_Short_Close = 12,     // 上期所期货昨仓空头平仓
  OrderSide_Margin_Bid = 13,             // 证券、基金、债券融资买入
  OrderSide_Margin_Ask = 14,             // 证券、基金、债券融券卖出
  OrderSide_Short_CoveredOpen = 15,      // 期权备兑开仓
  OrderSide_Short_CoveredClose = 16,     // 期权备兑平仓
  OrderSide_ETF_Create = 17,             // ETF申购
  OrderSide_ETF_Redeem = 18,             // ETF赎回
  OrderSide_Reverse_Repurchase = 19,     // 逆回购
  OrderSide_Margin_PayBack_Sell = 20,    // 买券还券
  OrderSide_Margin_PayBack_Buy = 21,     // 卖券还款
  OrderSide_Margin_PayBack_Stock = 22,   // 现券还券
  OrderSide_Margin_PayBack_Cash = 23,    // 直接还款
  OrderSide_Margin_MortgageIn = 24,      // 担保品转入
  OrderSide_Margin_MortgageOut = 25,     // 担保品转出
  OrderSide_Repurchase = 26,             // 正回购
  OrderSide_IPO_Bid = 27,                // 新股申购
  OrderSide_AHFPT_Bid = 28,              // 科创板盘后定价买入
  OrderSide_AHFPT_Ask = 29,              // 科创板盘后定价卖出
  OrderSide_Margin_MoreStockTrans = 30,  // 余券划转
  OrderSide_Allotment_Shares = 31,       // 配股认购
  OrderSide_ETF_Create_OTC = 33,         // 场外ETF申购
  OrderSide_ETF_Redeem_OTC = 34,         // 场外ETF赎回
  OrderSide_Bond_Swap = 35,              // 债券转股
  OrderSide_Bond_Sell_Back = 36,         // 债券回售
  OrderSide_Pledge_In = 37,              // 质押式回购入库
  OrderSide_Pledge_Out = 38,             // 质押式回购出库
};

// 持仓类型
enum PositionSide {
  PositionSide_Long = 1,           // 多仓
  PositionSide_Short = 2,          // 空仓
  PositionSide_Short_Covered = 3,  // 备兑空仓
};

/**
 * 成交回报类型定义
 */
enum TradeReportType {
  TradeReportType_Normal = 1,         // 普通回报
  TradeReportType_Cancel = 2,         // 撤单回报
  TradeReportType_Abolish = 3,        // 普通废单回报
  TradeReportType_InsideCancel = 4,   // 内部撤单回报，还未到交易所便被撤下来
  TradeReportType_CancelAbolish = 5,  // 撤单废单回报
};

/**
 * 资金账户类型定义
 */
enum AccountType {
  AccountType_Placeholder = 0,
  AccountType_Stock = 1,       // 股票
  AccountType_Futures = 2,     // 期货
  AccountType_Options = 3,     // 期权
  AccountType_Margin = 4,      // 融资融券
  AccountType_SHHK_Stock = 5,  // 沪港通
  AccountType_SZHK_Stock = 6,  // 深港通
  AccountType_ExtFund = 7,     // 场外基金
  AccountType_Gold = 8,        // 黄金
  AccountType_Forex = 9,       // 外汇
};

/**
 * 撤单标识
 */
enum CancelFlag {
  CancelFlag_False = 1,  // 假，不是撤单
  CancelFlag_True = 2,   // 真，是撤单
};

/**
 * 交易类型定义
 */
enum CreditType {
  CreditType_Normal = 1,        // 普通交易
  CreditType_CashLoan = 2,      // 融资交易
  CreditType_SecurityLoan = 3,  // 融券交易
};

/**
 * 投机套保标识
 */
enum HedgeFlag {
  HedgeFlag_Placeholder = 0,
  HedgeFlag_Speculation = 1,  // 投机
  HedgeFlag_Hedge = 2,        // 套保
  HedgeFlag_Arbitrage = 3,    // 套利
};

/**
 * 订单数据类型
 */
typedef struct t_Order {
  char strategy_id[LEN_ID];   // 策略id
  char run_id[LEN_ID];        // 策略运行id，代表策略的一次运行对应的id，即回测/模拟/实盘id
  char order_id[LEN_ID];      // 后台系统生成的内部订单id
  char cl_order_id[LEN_ID];   // 订单的客户方id
  char symbol[LEN_SYMBOL];    // 交易标的，格式为市场.证券ID或市场.合约ID

  char account_id[LEN_ACCOUNT_ID];  // 用户资金账户id
  int16_t account_type;             // 用户资金账户类型

  int32_t date;                 // 订单创建日期，格式：YYYYMMDD
  int32_t trade_seqno;          // 交易序号，即批次号
  int16_t order_status;         // 订单状态，参考OrderStatus定义
  int16_t order_type;           // 订单类型，参考OrderType定义
  int16_t side;                 // 买/卖，参考OrderSide定义
  int16_t credit_type;          // 信用类型，参考CreditType定义
  int32_t volume;               // 订单数量
  uint64_t price;               // 订单委托价，扩大1万倍
  int32_t filled_volume;        // 订单累计已完成数量
  uint64_t filled_turnover;     // 订单累计已完成金额，扩大1万倍
  uint64_t filled_price;        // 成交均价，扩大1万倍
  int64_t filled_market_value;  // 成交合约价值，扩大1万倍
  int32_t margin_ratio;         // 保证金比率，扩大1万倍
  int64_t marketdata_time;      // 触发订单的行情时间，精确到微秒，格式HHMMSSmmmuuu
  int64_t create_time;          // 订单创建时间，精确到微秒，格式HHMMSSmmmuuu
  int64_t update_time;          // 订单更新时间，精确到微秒，格式HHMMSSmmmuuu
  int64_t finish_time;          // 订单完成时间，精确到微秒，格式HHMMSSmmmuuu

  int16_t cancel_flag;          // 撤单标识，参考CancelFlag定义
  int32_t cancel_volume;        // 撤单量
  int32_t cancel_cnt;           // 撤单次数
  int64_t order_fee;            // 费用，扩大1万倍
  int32_t hedge_flag;         // 组合投机套保标志，用于期货交易
  char comb_id[LEN_COM_ID];     // 组合投机套保编号，用于期货交易
  char plate[LEN_PLATE];        // 期权交易板块

  int32_t err_code;               // 订单委托错误码
  char err_msg[LEN_ERR_MSG];      // 订单委托错误消息
} Order;

/**
 * 批量下单使用的订单请求类型
 */
typedef struct t_OrderReq {
  char order_id[LEN_ID];        // 后台系统生成的内部订单id，接口返回时填上
  char cl_order_id[LEN_ID];     // 订单的客户方id，异步下单时用户需要填上唯一id，以便委托响应时区分
  char symbol[LEN_SYMBOL];      // 交易标的，格式为市场.证券ID或市场.合约ID

  int16_t order_type;           // 订单类型，参考OrderType定义
  int16_t side;                 // 买/卖，参考OrderSide定义
  int32_t volume;               // 订单数量
  uint64_t price;               // 订单委托价，限价单使用，市价填写0，扩大1万倍
  int16_t hedge_flag;           // 期货投机、套利、套保标志，参考HedgeFlag定义
  char ext_info[LEN_EXT_INFO];  // 委托需要带入的扩展信息，格式为：key1=v1&key2=v2
                                // 目前支持的key有comb_id（UFX期货组合编号），plate（期权板块）
} OrderReq;

/**
 * 批量下单使用的订单请求类型
 */
typedef struct t_CancelReq {
  char orig_order_id[LEN_ID];   // 后台系统生成的订单id
  char cl_order_id[LEN_ID];     // 订单的客户方id，异步下单时用户需要填上唯一id，以便委托响应时区分
  char symbol[LEN_SYMBOL];      // 交易标的，格式为市场.证券ID或市场.合约ID

  int16_t order_type;           // 订单类型，参考OrderType定义
  int16_t side;                 // 买/卖，参考OrderSide定义
  int32_t volume;               // 订单数量
  uint64_t price;               // 订单委托价，限价单使用，市价填写0，扩大1万倍
  int16_t hedge_flag;           // 期货投机、套利、套保标志，参考HedgeFlag定义
  char ext_info[LEN_EXT_INFO];  // 委托需要带入的扩展信息，格式为：key1=v1&key2=v2
                                // 目前支持的key有comb_id（UFX期货组合编号），plate（期权板块）
} CancelReq;

/**
 * 成交数据类型
 */
typedef struct t_Trade {
  char strategy_id[LEN_ID];         // 策略ID
  char run_id[LEN_ID];              // 策略运行id，代表策略的一次运行对应的id，即回测/模拟/实盘id
  char order_id[LEN_ID];            // 后台系统生成的内部订单id
  char cl_order_id[LEN_ID];         // 订单的客户方id
  char symbol[LEN_SYMBOL];          // 交易标的，格式为市场.证券ID或市场.合约ID
  char account_id[LEN_ACCOUNT_ID];  // 用户资金账户id
  int16_t account_type;             // 用户资金账户类型
  int32_t date;                     // 成交日期，格式：YYYYMMDD
  int32_t trade_seqno;              // 交易序号，即批次号
  int16_t side;                     // 买/卖，参考OrderSide定义
  int16_t order_type;               // 订单类型，参考OrderType定义
  int16_t exec_type;                // 成交回报类型
  char exec_id[LEN_ID];             // 成交回报编号
  int32_t volume;                   // 成交数量
  uint64_t price;                   // 成交价格，扩大1万倍
  uint64_t turnover;                // 成交金额，扩大1万倍
  int64_t market_value;             // 成交合约市值，扩大1万倍
  uint64_t order_price;             // 委托价格，扩大1万倍
  int32_t order_volume;             // 委托数量
  int64_t transact_time;            // 成交时间，精确到微秒，格式HHMMSSmmmuuu
} Trade;

/**
 * 仓位数据类型
 */
typedef struct t_Position {
  char strategy_id[LEN_ID];         // 策略ID
  char run_id[LEN_ID];              // 策略运行id，代表策略的一次运行对应的id，即回测/模拟/实盘id
  char account_id[LEN_ACCOUNT_ID];  // 用户资金账户id
  int16_t account_type;             // 用户资金账户类型
  char symbol[LEN_SYMBOL];          // 持仓标的，格式为市场.证券ID或市场.合约ID
  int16_t side;                     // 持仓方向，参考PositionSide定义
  int32_t volume;                   // 总仓量
  int32_t avail_volume;             // 可用仓量
  int32_t frozen_volume;            // 冻结仓量
  int32_t today_volume;             // 今仓总量
  int32_t today_frozen_volume;      // 今仓冻结量
  int32_t today_avail_volume;       // 今仓可用量
  int32_t yesterday_volume;         // 昨仓总量
  int32_t yesterday_frozen_volume;  // 昨仓冻结量
  int32_t yesterday_avail_volume;   // 昨仓可用量
  uint64_t avg_cost;                // 开仓均价，扩大1万倍
  uint64_t hold_cost;               // 持仓均价，扩大1万倍
  int32_t create_day;               // 初始建仓日期，格式：YYYYMMDD
  int32_t update_day;               // 仓位变更日期，格式：YYYYMMDD
  int64_t create_time;              // 初始建仓时间，精确到微秒，格式HHMMSSmmmuuu
  int64_t update_time;              // 仓位变更时间，精确到微秒，格式HHMMSSmmmuuu
} Position;

/**
 * 风险收益指标数据类型
 */
typedef struct t_Indicator {
  char run_id[LEN_ID];          // 策略运行id，代表策略的一次运行对应的id，即回测/模拟/实盘id

  int32_t date;                 // 日期
  int32_t win_count;            // 盈利次数
  int32_t lose_count;           // 亏损次数

  double algorithm_return;      // 策略收益率
  double annual_algo_return;    // 策略年化收益率
  double benchmark_return;      // 基准收益率
  double algorithm_volatility;  // 策略波动率
  double benchmark_volatility;  // 基准波动率
  double alpha;                 // Alpha值，表示投资者获得与市场波动无关的回报
  double beta;                  // Beta值，表示投资的系统性风险，反映了策略对大盘变化的敏感性
  double sharpe;                // 夏普比率，表示每承受一单位总风险，会产生多少的超额报酬，可以同时对策略的收益与风险进行综合考虑
  double sortino;               // 索提诺比率，表示每承担一单位的下行风险，将会获得多少超额回报
  double information;           // 信息比率，衡量单位超额风险带来的超额收益
  double win_ratio;             // 胜率
  double day_win_ratio;         // 日胜率
  double max_drawdown;          // 最大回撤
} Indicator;

/**
 * 资金数据类型
 */
typedef struct t_Cash {
  char account_id[LEN_ACCOUNT_ID];  // 用户资金账户id
  int16_t account_type;             // 用户资金账户类型
  int64_t start_cash;               // 初始资金
  int64_t cash;                     // 当前资金
  int64_t avail_cash;               // 可用资金
  int64_t locked_cash;              // 冻结资金
  int64_t turnover;                 // 累计交易额
  int64_t today_turnover;           // 今日交易额
  int64_t today_close_value;        // 今日卖出券获取的资金额
  int64_t update_time;              // 帐户更新时间戳
} Cash;

/**
 * 订单委托应答详情
 */
typedef struct t_OrderRsp {
  char order_id[LEN_ID];      // 后台系统生成的内部订单id
  char cl_order_id[LEN_ID];   // 订单的客户方id
  int32_t err_code;           // 委托错误码
  char err_msg[LEN_ERR_MSG];  // 委托错误消息
} OrderRsp;

/**
 * 撤单详情
 */
typedef struct t_CancelDetail {
  char order_id[LEN_ID];         // 后台系统生成的内部订单id
  char cancel_order_id[LEN_ID];  // 订单对应的撤单委托id
  int32_t err_code;              // 撤单错误码
  char err_msg[LEN_ERR_MSG];     // 撤单错误消息
} CancelDetail;

/**
 * 还款应答详情
 */
typedef struct t_CreditPayBackRsp {
  char account_id[LEN_ACCOUNT_ID];  // 用户资金账户id
  int16_t account_type;             // 用户资金账户类型
  int64_t filled_back_amt;          // 实际还款金额
  int32_t err_code;                 // 委托错误码
  char err_msg[LEN_ERR_MSG];        // 委托错误消息
} CreditPayBackRsp;

/**
 * 信用资产数据
 */
typedef struct t_CreditAssetsDetail {
  char account_id[LEN_ID];  // 交易账号，目前是资金账号
  int16_t account_type;     // 交易账号类型，参考AccountType定义
  int16_t currency_type;    // 货币类型，参考CurrencyType定义
  int64_t avail_balance;    // 可用自有资金，即可买担保品资金，扩大一万倍
  int64_t fetch_balance;    // 可取资金，扩大一万倍
  int64_t frozen_balance;   // 冻结资金，扩大一万倍
  int64_t stock_balance;    // 证券市值，扩大一万倍
  int64_t fund_balance;     // 总资金，扩大一万倍
  int64_t asset_balance;    // 总资产，扩大一万倍
  int64_t avail_margin;     // 可用保证金，扩大一万倍
  int64_t credit_quota;     // 授信额度，扩大一万倍
  int64_t finance_quota;    // 可融资额度，扩大一万倍
  int64_t shortsell_quota;  // 可融券额度，扩大一万倍
  int64_t assure_ratio;     // 维持担保比例，扩大一万倍
  int64_t total_debt;       // 总负债，扩大一万倍
  int64_t fund_debt;        // 融资负债金额，包含融资利息及费用，扩大一万倍
  int64_t stock_debt;       // 融券负债金额，包含融券利息及费用，扩大一万倍
  int64_t fund_interest_fee;        // 融资利息及费用，扩大一万倍
  int64_t stock_interest_fee;       // 融券利息及费用，扩大一万倍
  int64_t shortsell_total_balance;  // 融券卖出总资金，扩大一万倍
  int64_t shortsell_avail_balance;  // 融券卖出可用资金（仅君睿柜台），扩大一万倍
  int64_t shortsell_frozen_balance; // 融券卖出冻结资金（仅君睿柜台），扩大一万倍
  int64_t enbuyback_avail_balance;  // 可买券还券资金，扩大一万倍
  int64_t fund_margin_profit;       // 融资盈亏，扩大一万倍
  int64_t stock_margin_profit;      // 融券盈亏，扩大一万倍
  int64_t fund_interest;            // 融资利息，扩大一万倍
  int64_t stock_interest;           // 融券利息，扩大一万倍
  int64_t fund_margin_balance;      // 融资市值，扩大一万倍
  int64_t stock_margin_balance;     // 融券市值，扩大一万倍
  int64_t fund_floating_deficit;    // 融资浮亏，扩大一万倍
  int64_t stock_floating_deficit;   // 融券浮亏，扩大一万倍
  int64_t fund_margin_profit_conversion;  // 融资盈亏折算，扩大一万倍
  int64_t stock_margin_profit_conversion;  // 融券盈亏折算，扩大一万倍
} CreditAssetsDetail;

/**
 * 融资合约数据
 */
typedef struct t_CreditFinanceDetail {
  char account_id[LEN_ID];    // 交易账号，目前是资金账号
  int16_t account_type;       // 交易账号类型，参考AccountType定义
  char symbol[LEN_SYMBOL];    // 交易标的，格式为市场.证券ID
  char name[LEN_SYMBOL];      // 证券名称
  char order_id[LEN_ID];      // 系统生成的订单id
  int16_t currency_type;      // 货币类型
  int16_t debt_status;        // 负债现状，0：未了结，1：已了结
  int32_t occur_date;         // 合约的发生日期
  int64_t total_balance;      // 合约的总金额，扩大一万倍
  int64_t cur_balance;        // 合约的当前未偿还金额，扩大一万倍
  int64_t total_interest_fee; // 合约的利息及费用总金额，扩大一万倍
  int64_t cur_interest_fee;   // 合约的当前未偿还利息及费用金额，扩大一万倍
  int64_t interest_rate;      // 利率，扩大一万倍
  int64_t repayable_balance;  // 可还款金额，扩大一万倍
  int64_t f_deal_bal;         // 期初应付融资款余额
  int64_t f_exp_cet_intr;     // 期初应付负债息费
  int64_t credit_repay_unfrz; // 当日归还负债金额
  int64_t all_fee_unfrz;      // 当日归还负债息费
  int32_t market;             // 市场
} CreditFinanceDetail;

/**
 * 融券合约数据
 */
typedef struct t_CreditShortsellDetail {
  char account_id[LEN_ID];    // 交易账号，目前是资金账号
  int16_t account_type;       // 交易账号类型，参考AccountType定义
  char symbol[LEN_SYMBOL];    // 交易标的，格式为市场.证券ID
  char name[LEN_SYMBOL];      // 证券名称
  char order_id[LEN_ID];      // 系统生成的订单id
  int16_t currency_type;      // 货币类型，参考CurrencyType定义
  int16_t debt_status;        // 负债现状，0：未了结，1：已了结
  int32_t occur_date;         // 合约的发生日期
  int64_t total_qty;          // 合约的融券总数量
  int64_t cur_qty;            // 合约的当前未偿还融券数量
  int64_t total_interest_fee; // 合约的利息及费用总金额，扩大一万倍
  int64_t cur_interest_fee;   // 合约的当前未偿还利息及费用金额，扩大一万倍
  int64_t interest_rate;      // 利率，扩大一万倍
  int64_t d_stk_bal;          // 期初应偿还融券总数
  int32_t market;             // 市场
  int64_t all_fee_unfrz;      // 当日归还负债息费
  int64_t stk_repay_unfrz;    // 当日归还负债数量
  int32_t end_date;           // 负债截至日期
} CreditShortsellDetail;

#endif  // HFT_SDK_TRADE_DEF_H__
