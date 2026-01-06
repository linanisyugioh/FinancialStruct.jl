c";
#pragma pack(push, 1)
typedef struct t_HKSecurityTick_HDB{
   uint32_t security_code;
   int64_t time;
   int32_t pre_close_price;
   int32_t price;
   uint64_t shares_traded;
   int64_t turnover;
   int32_t high_price;
   int32_t low_price;
   int32_t last_price;
   int32_t vwap;
   int32_t price_b[10];
   uint64_t quantity_b[10];
   int32_t price_s[10];
   uint64_t quantity_s[10];
   int32_t open_price;
}HKSecurityTick_HDB;

typedef struct t_HKIndexTick_HDB{
   char index_code[11];
   char index_status;
   int64_t index_time;
   int64_t index_value;
   int64_t net_chg_prev_day;
   int64_t high_value;
   int64_t low_value;
   int64_t eas_value;
   int64_t index_turnover;
   int64_t open_value;
   int64_t close_value;
   int64_t previous_ses_close;
   int64_t index_volume;
   int32_t net_chg_prev_day_pct;
   char exception;
   char filler[3];
}HKIndexTick_HDB;

typedef struct t_HKTradeTicker_HDB{
   uint32_t security_code;
   uint32_t ticker_id;
   int32_t price;
   uint64_t agg_quantity;
   uint64_t trade_time;
   int16_t trd_type;
   char trd_cancel_flag;
   char filler;
}HKTradeTicker_HDB;

typedef struct t_HKCodeInfo_HDB{
   uint32_t security_code;
   char market_code[4];
   char isin_code[12];
   char instrument_type[4];
   char product_type;
   char filler1;
   char spread_table_code[2];
   char security_short_name[40];
   char currency_code[3];
   char gccs_name[60];
   char gb_name[60];
   uint32_t lot_size;
   char filler12[4];
   int32_t pre_close_price;
   char vcm_flag;
   char short_sell_flag;
   char cas_flag;
   char ccas_flag;
   char dummy_security_flag;
   char filler2;
   char stamp_duty_flag;
   char filler3;
   uint32_t listing_date;
   uint32_t delisting_date;
   char free_text[38];
   char filler4[62];
   char pos_flag;
   int32_t pos_upper_limit;
   int32_t pos_lower_limit;
   char filler5[41];
   char efn_flag;
   uint32_t accrued_interest;
   uint32_t coupon_rate;
   char filler6[62];
   uint32_t conversion_ratio;
   int32_t strike_price1;
   int32_t strike_price2;
   uint32_t maturity_date;
   char call_put_flag;
   char style;
   char filler7[80];
}HKCodeInfo_HDB;

#pragma pack(pop)"
HKSecurityTick = c"struct t_HKSecurityTick_HDB"
HKIndexTick = c"struct t_HKIndexTick_HDB"
HKTradeTicker = c"struct t_HKTradeTicker_HDB"
HKCodeInfo = c"struct t_HKCodeInfo_HDB"
hkdata = (HKSecurityTick, HKIndexTick, HKTradeTicker, HKCodeInfo, )
