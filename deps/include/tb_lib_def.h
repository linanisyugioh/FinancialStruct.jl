
#ifndef HFT_TB_LIB_DEF_H__
#define HFT_TB_LIB_DEF_H__

/**
 * 扩展盘口档位定义
 */
static const int TB_EXT_LEVELS = 10;

typedef struct t_OnlyTBTickData {
	uint32_t ticker;                          /// 快照计数器，从0开始，每生成一个新的快照加1.
	int build_status;                         /// 当前撮合状态，0为正常，非0不正常

	bool is_halt;                             /// 该标的是否处于临时停牌状态

	uint32_t virtual_match;                   /// 集合竞价虚拟成交价
	int64_t virtual_volume;                   /// 集合竞价虚拟成交量

	int64_t total_bid_amount;                 /// 总的委托买入金额
	int64_t total_ask_amount;                 /// 总的委托卖出金额

	int64_t total_bid_orders;                 /// 总的委托买入笔数
	int64_t total_ask_orders;                 /// 总的委托卖出笔数

	int64_t up_limit_vol;                     /// 涨停价委托量
	int64_t up_limit_orders;                  /// 涨停价委托笔数

	int64_t down_limit_vol;                   /// 跌停价委托量
	int64_t down_limit_orders;                /// 跌停价委托笔数

	int ask_orders_num[TB_EXT_LEVELS];        /// 每个卖盘档位对应的委托数量
	int bid_orders_num[TB_EXT_LEVELS];        /// 每个买盘档位对应的委托数量

	int64_t ask_dists_vol[TB_EXT_LEVELS];     /// 离开卖一价一段距离的盘口挂单量
	int64_t bid_dists_vol[TB_EXT_LEVELS];     /// 离开买一价一段距离的盘口挂单量
}OnlyTBTickData;

#endif	// HFT_TB_LIB_DEF_H__
