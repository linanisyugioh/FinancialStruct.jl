/**
 * @file    md_def.h
 * @brief   hftsdk 行情数据结构定义
 * @Copyright (c) 2022 上海紫虚科技有限公司
 */

#ifndef HFT_SDK_MD_DEF_H__
#define HFT_SDK_MD_DEF_H__

#include <stdint.h>

#pragma pack(push, 1)

/**
 * Tick数据类型定义
 */
enum MDTickType {
  MDTickType_SecurityTick = 0,  //证券tick
  MDTickType_IndexTick,         //指数Tick
  MDTickType_FuturesTick,       //期货tick
  MDTickType_OptionsTick,       //期权tick
  MDTickType_TickByTick,        //逐笔数据
  MDTickType_OrderQueue,        //委托队列
  MDTickType_SecurityKdata,     //证券k线数据
};

/**
 * 交易市场枚举
 */
enum MarketId {
  MarketID_Null = 0,
  MarketID_SH,
  MarketID_SZ,
  MarketID_CFFEX,
  MarketID_CZCE,
  MarketID_DCE,
  MarketID_SHFE,
  MarketID_HK,
  MarketID_SGE,
  MarketID_CFETS,
  MarketID_SHOP,
  MarketID_SZOP,
};

/**
 * 证券tick数据
 */
typedef struct t_SecurityTickData {
  char symbol[12];                  //证券代码（带交易所代码）
  int32_t time;                     //时间(HHMMSSmmm)
  int32_t status;                   //状态
  uint32_t pre_close;               //前收盘价
  uint32_t open;                    //开盘价
  uint32_t high;                    //最高价
  uint32_t low;                     //最低价
  uint32_t match;                   //最新价
  uint32_t ask_price[10];           //申卖价
  uint32_t ask_vol[10];             //申卖量
  uint32_t bid_price[10];           //申买价
  uint32_t bid_vol[10];             //申买量
  uint32_t num_trades;              //成交笔数
  int64_t volume;                   //成交总量
  int64_t turnover;                 //成交总金额
  int64_t total_bid_vol;            //委托买入总量
  int64_t total_ask_vol;            //委托卖出总量
  uint32_t weighted_avg_bid_price;  //加权平均委买价格
  uint32_t weighted_avg_ask_price;  //加权平均委卖价格
  int32_t iopv;                     // IOPV净值估值
  int32_t yield_to_maturity;        //到期收益率
  uint32_t high_limited;            //涨停价
  uint32_t low_limited;             //跌停价
  char prefix[4];                   //证券信息前缀
  int32_t syl1;  //市盈率1,2位小数.股票：价格/上年每股利润,债券：每百元应计利息
  int32_t syl2;  //市盈率2,2位小数.股票：价格/本年每股利润,债券：到期收益率,基金：每百份的IOPV
                 //或净值 权证：溢价率
  int32_t sd2;   //升跌2（对比上一笔）
  char trading_phase_code[8];  //交易状态代码,上交所与深交所字段含义不同，参见以下注解：
  // 上交所：该字段为8位字符串，左起每位表示特定的含义，无定义则填空格。
  // 第1位：‘S’表示启动（开市前）时段，‘C’表示集合竞价时段，‘T’表示连续交易时段，‘B’表示休市时段，‘E’表示闭市时段，
  //        ‘P’表示产品停牌，‘M’表示可恢复交易的熔断时段（盘中集合竞价），‘N’表示不可恢复交易的熔断时段（暂停交易至闭市），
  //        ‘D’表示集合竞价阶段结束到连续竞价阶段开始之前的时段（如有）。
  // 第2位： ‘0’表示此产品不可正常交易，‘1’表示此产品可正常交易，无意义填空格。
  // 第3位：‘0’表示未上市，‘1’表示已上市。
  // 第4位：‘0’表示此产品在当前时段不接受进行新订单申报，‘1’表示此产品在当前时段可接受进行新订单申报。无意义填空格。
  //
  // 深交所： 产品所处的交易阶段代码
  // 第0位： S=启动（开市前）, O=开盘集合竞价, T=连续竞价, B=休市,
  // C=收盘集合竞价,
  //         E=已闭市, H=临时停牌, A=盘后交易, V=波动性中断
  // 第1位： 0=正常状态, 1=全天停牌
  int32_t pre_iopv;  //基金T-1日收盘时刻IOPV.仅标的为基金时有效
} SecurityTickData;

/**
 * 指数Tick数据
 */
typedef struct t_IndexTickData {
  char symbol[12];    //证券代码（带交易所代码）
  int32_t time;       //时间(HHMMSSmmm)
  int32_t open;       //今开盘指数
  int32_t high;       //最高指数
  int32_t low;        //最低指数
  int32_t match;      //最新指数
  int64_t volume;     //参与计算相应指数的交易数量
  int64_t turnover;   //参与计算相应指数的成交金额
  int32_t pre_close;  //前收盘指数
} IndexTickData;

/**
 * 期货tick数据
 */
typedef struct t_FuturesTickData {
  char symbol[24];            //证券代码（带交易所代码）
  int32_t time;               //时间(HHMMSSmmm)
  int32_t status;             //状态
  int64_t pre_open_interest;  //昨持仓
  int64_t pre_close;         //昨收盘价
  int64_t pre_settle_price;  //昨结算价
  int64_t open;              //开盘价
  int64_t high;              //最高价
  int64_t low;               //最低价
  int64_t match;             //最新价
  int64_t volume;             //成交总量
  int64_t turnover;           //成交总金额
  int64_t open_interest;      //持仓总量
  int64_t close;             //今收盘
  int64_t settle_price;      //今结算价
  int64_t high_limited;      //涨停价
  int64_t low_limited;       //跌停价
  int32_t pre_delta;          //昨虚实度
  int32_t curr_delta;         //今虚实度
  int64_t ask_price[5];      //申卖价
  uint32_t ask_vol[5];        //申卖量
  int64_t bid_price[5];      //申买价
  uint32_t bid_vol[5];        //申买量
  char trading_status;        //交易状态
} FuturesTickData;

/**
 * 期权tick数据
 */
typedef struct t_OptionsTickData {
  char symbol[24];              // 证券代码（带交易所代码）
  int32_t data_timestamp;       // 时间戳 HHMMSSmmm
                                // 如果期权合约的产品代码为“00000000”，则表示行情时间
  int64_t pre_settle_price;     // 昨日结算价 4 decimal places
  int64_t settle_price;         // 今日结算价  4 decimal places
  int64_t open;                 // 开盘价.
                                // 如果期权合约的产品代码为“00000000”,则表示收盘标志,111111表示收盘
  int64_t high;                 // 最高价
  int64_t low;                  // 最低价
  int64_t match;                // 现价.如果期权合约的产品代码为“00000000”，则表示记录数
  int64_t auction_price;        // 波动性中断参考价 4 decimal places
  int64_t auction_qty;          // 波动性中断集合竞价虚拟匹配量
  int64_t total_long_position;  // 当前合约未平仓数量
  int64_t bid_vol[5];           // 申买量
  int64_t bid_price[5];         // 申买价
  int64_t ask_vol[5];           // 申卖量
  int64_t ask_price[5];         // 申卖价
  int64_t volume;               // 成交总量  Trade volume of this security
  int64_t turnover;             // 成交总金额（2位小数）Turnover of this security
  char trading_phase_code[8];   // 成交阶段代码,交易时间段由4位扩至8位
  // 期权交易状态，取值范围如下：
  // 该字段为4位字符串，左起每位表示特定的含义，无定义则填空格。
  // 第1位： 'S' 表示启动（开市前）时段，‘C’表示集合竞价时段，‘T’表示连续交易时段，‘B’表示休市时段，
  //         'E' 表示闭市时段，‘V’表示波动性中断，‘P’表示临时停牌、‘U’收盘集合竞价。‘M’表示可恢复交易的熔断（盘中集合竞价）,
  //         'N' 表示不可恢复交易的熔断（暂停交易至闭市）
  // 第2位： '0' 表示未连续停牌，‘1’表示连续停牌。（预留，暂填空格）
  // 第3位： '0' 表示不限制开仓，‘1’表示限制备兑开仓，‘2’表示卖出开仓，‘3’表示限制卖出开仓、备兑开仓，
  //         '4' 表示限制买入开仓，‘5’表示限制买入开仓、备兑开仓，‘6’表示限制买入开仓、卖出开仓，‘7’表示限制买入开仓、卖出开仓、备兑开仓
  // 第4位： '0' 表示此产品在当前时段不接受进行新订单申报，‘1’表示此产品在当前时段可接受进行新订单申报。
  // 第5位至第8位，预留（暂填空格）
  char transact_time_only[12];  // 最近询价时间，格式为HH:MM:SS.000。当日没有询价时，显示默认值00:00:00.000。
  int64_t num_trades;           // 成交笔数
  int64_t buy_avg_price;        // x3=买入汇总（总量及加权平均价）
  int64_t buy_volume_trade;     // x3=买入汇总（总量及加权平均价）
  int64_t sell_avg_price;       // x4=卖出汇总（总量及加权平均价）
  int64_t sell_volume_trade;    // x4=卖出汇总（总量及加权平均价）
} OptionsTickData;

/**
 * 证券k线数据
 */
typedef struct t_SecurityKdata {
  char symbol[24];        // 证券代码（带交易所代码）
  uint32_t date;          // 日期       YYYYMMDD
  int32_t time;           // 时间(北京时间) HHMMSS
  int64_t pre_close;      // 前收盘价         单位：1/100分
  int64_t open;           // 开盘价      单位：1/100分,比如1表示0.0001元
  int64_t high;           // 最高价      单位：1/100分
  int64_t low;            // 最低价      单位：1/100分
  int64_t close;          // 收盘价      单位：1/100分
  int64_t volume;         // 分钟内成交量   单位：该证券的最小交易单位，比如股票为“股”
  int64_t turnover;       // 分钟内成交额   单位：元
  int64_t open_interest;  // 累计持仓总量
  int64_t pre_settle_price; // 前结算价      单位：1/100分
  int64_t settle_price; // 结算价      单位：1/100分
} SecurityKdata;

/**
 * 代码基本信息
 */
typedef struct t_CodeInfo {
  char symbol[24];           // 证券代码（带交易所代码）
  int32_t sec_type;          // 代码类型,1：股票,2:期货,3:期权
  char sec_name[24];         // 代码中文名称，编码为utf8
  uint32_t date;             // 日期 YYYYMMDD
  uint32_t high_limited;     // 涨停价，扩大10000倍
  uint32_t low_limited;      // 跌停价，扩大10000倍
  int32_t multiplier;        // 合约乘数，扩大10000倍
  int32_t margin_ratio;      // 保证金比率，扩大10000倍
  int32_t price_tick;        // 价格变更单位，扩大10000倍
  int64_t capital;           // 流通股本数
  uint32_t cap_change_date;  // 股本变动日期
  uint32_t trade_date_in;    // 上市日期YYYYMMDD
  uint32_t trade_date_out;   // 退市日期YYYYMMDD(最后一个交易日)
  uint8_t is_halt;           // 是否停牌，1：停牌，0：正常交易

  // 只对期权有效
  uint32_t margin_unit;         // 单位保证金	N16(2)
                                // 当日持有一张合约所需要的保证金数量，精确到分
  int32_t margin_ratio_param1;  // 保证金计算比例参数一	N6(2)
                                // 保证金计算参数，单位：%
  int32_t margin_ratio_param2;  // 保证金计算比例参数二	N6(2)
                                // 保证金计算参数，单位：%
} CodeInfo;

/**
 * 交易日期数据
 */
typedef struct t_TradeDate {
  int64_t utc_time;  // 交易日utc时间
  uint32_t date;     // 交易日时间YYYYMMDD
} TradeDate;

/**
 * 权息数据
 */
typedef struct t_QxData {
  char symbol[12];      // 证券代码（带交易所代码）
  int32_t date;         // 除权除息日期 YYYYMMDD
  int32_t bonus_ratio;  // 送股比例，扩大10000倍
  int32_t dividend;     // 红利，扩大10000倍
  int32_t allot_ratio;  // 配股比例，扩大10000倍
  int32_t allot_price;  // 配股价，扩大10000倍
  int32_t add_ratio;    // 增发比例，扩大10000倍
  int32_t add_price;    // 增发价，扩大10000倍
  int32_t factor;       // 折算系数，一般用于基金
} QxData;

/**
 * @brief 沪深逐笔委托行情数据
 */
typedef struct t_TickByTickEntrust {
  int32_t channel_no;   // 频道代码
  char side;            // '1':买; '2':卖; 'G':借入; 'F':出借
  char ord_type;        // SZ:订单类别: '1': 市价; '2': 限价; 'U': 本方最优
                        // SH:订单类别: 'A': 增加  'D': 删除
  char res[2];          // 预留字段
  int64_t seq;          // 委托序号(在同一个channel_no内唯一，从1开始连续)
  int64_t price;        // 委托价格,扩大10000倍
  int64_t qty;          // SZ:委托数量  SH:委托剩余量
  int64_t order_no;     // SH:逐笔委托原始委托号
  int64_t order_index;  // SH:逐笔委托序号
} TickByTickEntrust;

/**
 * @brief 沪深逐笔成交行情数据
 */
typedef struct t_TickByTickTrade {
  int32_t channel_no;   // 频道代码
  char trade_flag;      // SH: 内外盘标识('B':主动买; 'S':主动卖; 'N':未知)
                        // SZ: 成交标识('4':撤; 'F':成交)
  char res[3];          // 预留字段
  int64_t seq;          // 成交序号(在同一个channel_no内唯一，从1开始连续)
  int64_t price;        // 成交价格,扩大10000倍
  int64_t qty;          // 成交量
  int64_t money;        // 成交金额,扩大10000倍
  int64_t bid_no;       // 买方订单号
  int64_t ask_no;       // 卖方订单号
  
} TickByTickTrade;

/**
 * @brief 沪深逐笔行情数据
 */
typedef struct t_TickByTickData {
  char symbol[12];    // 证券代码（带交易所代码）
  char type;          // 委托:'0', 成交:'1'
  char res[3];        // 预留字段
  int64_t data_time;  // 委托时间 or 成交时间

  union TickByTickMD {
    TickByTickEntrust entrust;  // 逐笔委托
    TickByTickTrade trade;      // 逐笔成交
  } data;
} TickByTickData;

/**
 * @brief 委托队列数据项
 */
typedef struct t_OrderQueueItemData {
  int32_t time;         // 委托时间(HHMMSSmmm)
  int32_t side;         // 买卖方向('B': Bid 'S': Ask)
  int32_t price;        // 委托价格，扩大10000倍
  int32_t order_num;    // 委托数量
  int32_t item_num;     // 委托明细数量，最大200个
  int32_t volume[200];  // 委托明细
} OrderQueueItemData;

/**
 * @brief 委托队列数据
 */
typedef struct t_OrderQueueData {
  char symbol[12];            // 证券代码（带交易所代码）
  char res[4];                // 预留字段
  OrderQueueItemData item[2]; // 2档委托队列明细数据
} OrderQueueData;

/**
 * @brief 市场日期更新消息
 */
typedef struct t_DateUpdateData {
  char market[8];  // 市场
  int32_t date;    // 日期 YYYYMMDD
} DateUpdateData;

#pragma pack(pop)


#endif  // HFT_SDK_MD_DEF_H__