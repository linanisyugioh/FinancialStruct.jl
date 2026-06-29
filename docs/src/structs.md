# 结构体说明文档

本文档详细描述了 `FinancialStruct.jl` 中所有结构体的字段定义、类型与用途。

---

## 模块使用说明

### 模块概述

`FinancialStruct` 是一个金融数据结构定义库，基于 [CBinding.jl](https://github.com/analytech-solutions/CBinding.jl) 将 C 头文件中定义的结构体直接映射为 Julia 可用的位类型（bitstype），使 Julia 能与外部 SDK / 二进制文件 / 历史数据库（HDB）无缝互操作，且**无需重复定义字段、无内存拷贝开销**。

模块加载时会自动：

1. 解析 [deps/include/](../../deps/include/) 下的 C 头文件（`md_def.h`、`trade_def.h`、`om_data_types.h`、`tb_lib_def.h`，以及上期 CTP 的 `ThostFtdcUserApiDataType.h` / `ThostFtdcUserApiStruct.h`）；
2. 调用 `include("struct/*.jl")` 加载所有 HDB 二进制存储结构定义；
3. 为每个结构体创建对应的 Julia bitstype 别名（前缀 `c`，如 `cOrder`、`cTrade`、`cSecurityTickData`；CTP 结构体使用 `cCtp*` 前缀，如 `cCtpInputOrder`）；
4. 定义 `HRetCode`、`HFieldType`、`HFieldEncodeOp`、`HFieldFlag`、`HClientCreateFileOption` 等 Julia 端 `@enum`；其余 C 枚举常量（`OrderStatus_New`、`MarketID_SH`、`HedgeFlag_Hedge` 等）需通过 `c"…"` 字符串宏访问，或直接使用整数字面量。

### 安装

```julia
using Pkg
Pkg.add(path="d:/workspace/julia打包/FinancialStruct.jl")  # 替换为实际路径
```

详细安装步骤请参见仓库根目录的 [INSTALL.md](../../INSTALL.md)。

### 快速开始

```julia
using FinancialStruct
using CBinding   # 提供 Cptr / Carray 等类型

# 1) 通过关键字参数一次性构造（**唯一** 推荐的"赋值"方式）
#    CBinding 生成的结构体是不可变 isbits 类型，构造完成后字段值无法再被修改。
#    注意：枚举常量（OrderStatus_New 等）未直接导出，要么用 `c"OrderStatus_New"`，
#    要么直接传它的整数字面量。项目里常用整数字面量（见 ema.jl）。
order = FinancialStruct.cOrder(
    order_status = Int16(2),              # 2 = OrderStatus_New，见 trade_def.h
    volume       = Int32(1000),
    price        = UInt64(1_2345_0000),   # 价格扩大1万倍：12.345 元
)
@info "订单" status=order.order_status volume=order.volume price=order.price

# 2) char 数组字段必须用 Carray 包装好后再传入；项目里通用的工具函数：
function str_to_carray_memcpy(s::AbstractString, ::Val{N}) where {N}
    ref = Libc.malloc(Carray{Int8, N}())
    GC.@preserve s ref begin
        len = min(ncodeunits(s), N)
        unsafe_copyto!(
            Ptr{UInt8}(Base.unsafe_convert(Ptr{Carray{Int8, N}}, ref)),
            pointer(s), len,
        )
    end
    return ref[]
end

order = FinancialStruct.cOrder(
    symbol       = str_to_carray_memcpy("SH.600000", Val(32)),  # LEN_SYMBOL = 32
    cl_order_id  = str_to_carray_memcpy("cli-001",   Val(32)),  # LEN_ID = 32
    volume       = Int32(100),
    price        = UInt64(10_5000),
)

# 3) 从回调指针读取（典型 SDK 回调签名 (Cptr{cTrade}, Ptr{Cvoid}) -> Cvoid）：
#    char 字段通过 Cptr 取 Ptr{UInt8} 再 unsafe_string；其他字段 unsafe_load 后 .field 访问
function on_trade(Ptrade::Cptr{FinancialStruct.cTrade}, user_data::Ptr{Cvoid})::Cvoid
    trade    = unsafe_load(Ptrade)
    symbol   = unsafe_string(convert(Ptr{UInt8}, Ptrade.symbol))
    order_id = unsafe_string(convert(Ptr{UInt8}, Ptrade.order_id))
    @info "trade" symbol order_id price=trade.price volume=trade.volume
    nothing
end
```

> ⚠️ `order.field = v`、`Ref(order)[].field = v`、`Cptr{cOrder}(p).field = v` 这三种"赋值"
> 写法**全部都会失败**（前两种 CBinding 在值语义上禁用，第三种当字段是 primitive 时
> 走 `store!(..., ::Val{false}, val)` 分支也会抛 `Unexpected type ... in store! function`）。
> 一旦需要"修改"字段，**唯一可靠**做法是基于已有值用 kwargs 构造新值：
>
> ```julia
> order2 = FinancialStruct.cOrder(order;
>     volume = order.volume + Int32(100),   # 增量更新
> )
> ```

> 💡 **枚举常量访问**：模块里的 `OrderStatus_New` / `HedgeFlag_Hedge` 等并未导出为裸名，要用必须写 `c"OrderStatus_New"`（需 `using CBinding` 提供 `@c_str` 宏），或者直接用整数字面量（推荐，与 ema.jl 一致）。各枚举值定义见 [deps/include/trade_def.h](../../deps/include/trade_def.h)。

### 命名约定

| 命名风格 | 含义 | 示例 |
|---|---|---|
| `c<Name>` | Julia 中的 bitstype 别名，对应 C 结构体；可直接通过 `unsafe_load` / `unsafe_store!` 与外部交互 | `cOrder`、`cTrade`、`cPosition`、`cFuOrder` |
| `cCtp<Name>` | CTP 接口结构体的 bitstype 别名；从 `CThostFtdc<Name>Field` 去掉 `CThostFtdc` 前缀与 `Field` 后缀生成 | `cCtpInputOrder`、`cCtpOrder`、`cCtpTrade`、`cCtpDepthMarketData` |
| `<Name>` (HDB) | HDB 二进制存储用的紧凑结构（`#pragma pack(push,1)`）；变量绑定到 `c"struct t_<Name>_HDB"` | `SecurityKdata`、`SHProductInfo`、`SZStock` |
| `<集合名>` | 同一类别 HDB 结构的 tuple，便于批量遍历或注册 | `bar`、`baseinfo`、`marketdata` |
| `H<Name>` | HDB 通用元信息 Julia 结构（用于描述 HDB 文件中字段元数据） | `HDataField`、`HDataType`、`HDataItem`、`HCodeInfo` |
| `<Enum>_<Member>` | 枚举常量；可通过 `Int(枚举值)` 取整数值 | `OrderStatus_Filled`、`HRetCode_OK`、`HedgeFlag_Hedge` |

### 字段访问技巧

CBinding 把 `char[N]` 字段映射成 `Carray{Int8, N}`（在打印时显示为 `NTuple{N, Cchar}` 形式）。围绕它的读 / 写有两组标准做法：

#### 写：构造时一次性传 Carray

构造 `cOrder` / `cTrade` / `cOmOrder` 等需要 char 字段时，**必须**先把 Julia String 打包成 `Carray{Int8, N}()`：

```julia
using CBinding

"""把 Julia String 写入一段长度为 N 的 Carray{Int8,N} 缓冲区并返回值副本。
   项目通用工具，等价于 HFTCTP.str_to_carray_memcpy（来自 HFTCTP.jl）。"""
function str_to_carray_memcpy(s::AbstractString, ::Val{N}) where {N}
    ref = Libc.malloc(Carray{Int8, N}())
    GC.@preserve s ref begin
        len = min(ncodeunits(s), N)
        unsafe_copyto!(
            Ptr{UInt8}(Base.unsafe_convert(Ptr{Carray{Int8, N}}, ref)),
            pointer(s), len,
        )
    end
    return ref[]
end

# 实际使用（节选自 ema.jl，订单管理初始化场景）
order = FinancialStruct.cOmOrder(
    order_id    = str_to_carray_memcpy("pos_order",         Val(64)),  # OM_LEN_ID
    strategy_id = str_to_carray_memcpy("EMA_CFFEX.IC_1_3_12", Val(32)), # OM_LEN_CODE
    run_id      = str_to_carray_memcpy("S-CTP-TEST1",        Val(64)),
    account_id  = str_to_carray_memcpy("1086001286",         Val(64)),
    cl_order_id = str_to_carray_memcpy("pos_order_id",       Val(32)),
    code        = str_to_carray_memcpy("CFFEX.IC2606",       Val(32)),
    product     = str_to_carray_memcpy("IC",                 Val(32)),
    security    = str_to_carray_memcpy("中金所IC",            Val(64)),
    # 其余 primitive 字段直接传值即可
    oper_date    = 20260521,
    account_type = 2,
    status       = 4,
    side         = 5,
    volume       = 4,
    price        = 85122000,
    contract_multiply = 200,
    filled_volume     = 4,
    filled_turnover   = 68100796800,
)
```

> 各字段长度（`Val(N)` 的 `N`）请按头文件宏定义传入：`LEN_ID=32`、`LEN_SYMBOL=32`、`LEN_ACCOUNT_ID=64`、`LEN_ERR_MSG=128`、`LEN_COM_ID=32`、`LEN_PLATE=4`、`LEN_EXT_INFO=128`；`om_data_types.h` 里则是 `OM_LEN_ID=64`、`OM_LEN_ACCOUNT_ID=64`、`OM_LEN_ERR_MSG=128`、`OM_LEN_CODE=32`、`OM_LEN_PRODUCT=32`、`OM_LEN_SECURITY=64`。**长度不匹配会编译期报错**。

#### 读：从指针/值取 char 字段

回调中拿到的是 `Cptr{T}`，对它的 char 字段做 `convert(Ptr{UInt8}, ptr.field)` 再 `unsafe_string` 就能拿到 Julia `String`：

```julia
function on_order(Porder::Cptr{FinancialStruct.cOrder}, user_data::Ptr{Cvoid})::Cvoid
    order    = unsafe_load(Porder)                                    # 整体拷贝为值
    symbol   = unsafe_string(convert(Ptr{UInt8}, Porder.symbol))      # char 字段 → String
    order_id = unsafe_string(convert(Ptr{UInt8}, Porder.order_id))

    # primitive 字段：直接通过 order.field 访问
    if order.cancel_flag == 2
        order_id = unsafe_string(convert(Ptr{UInt8}, Porder.cl_order_id))
    end

    # 遍历所有字段打印（debug 用）
    for name in fieldnames(FinancialStruct.cOrder)
        @info name => repr(getproperty(order, name))
    end
    nothing
end
on_order_c = @cfunction(on_order, Cvoid, (Cptr{FinancialStruct.cOrder}, Ptr{Cvoid}))
```

### 价格 / 倍数转换

所有价格类字段以**整数（扩大 10000 倍）**存储，避免浮点精度问题；手续费类字段扩大 **100000 倍**。读写时记得做缩放：

```julia
const PRICE_SCALE = 10_000
const FEE_SCALE   = 100_000

# 写入：12.345 元（构造时一次性传入）
order = FinancialStruct.cOrder(
    price = UInt64(round(12.345 * PRICE_SCALE)),
)

# 读取：还原为浮点
price_yuan = order.price / PRICE_SCALE

# 实战节选（来自 ema.jl）：根据可用权益计算下单手数
margin_ratio = bf.margin_ratio[symbol][1] / 10000.0
multiplier   = bf.multiplier[symbol]
volume       = Int(floor(equity * pos_ratio / (margin_ratio * ask_price * multiplier)))
```

### 与外部 SDK 互操作

C 头文件直接编译的 isbits 类型 + 1 字节对齐意味着 `cOrder` / `cTrade` / `cFuturesTickData` 等可以直接出现在 `@cfunction` 签名里、由 SDK 通过 `Cptr{T}` 回调进来。下面是 `HFTCTP.jl` 在 [ema.jl](../../ema.jl) 里的真实用法：

```julia
import FinancialStruct.cFuOrder         as cOrder
import FinancialStruct.cFuTrade         as cTrade
using  FinancialStruct: cFuturesTickData, cOrderRsp, cCancelDetail

# 1) 注册行情回调（tick 推送）
function on_futures_tick(tickdata::Cptr{cFuturesTickData}, user_data::Ptr{Cvoid})::Cvoid
    symbol = unsafe_string(convert(Ptr{UInt8}, tickdata.symbol))
    ftick  = unsafe_load(tickdata)               # 拷贝出值，后续随便用
    last_price = ftick.match
    ask_price  = ftick.ask_price[1]              # 数组字段直接 index
    bid_price  = ftick.bid_price[1]
    # ... 业务处理
    nothing
end
on_futures_tick_c = @cfunction(on_futures_tick, Cvoid,
                               (Cptr{cFuturesTickData}, Ptr{Cvoid}))
HFTCTP.md_set_futures_tick_callback(on_futures_tick_c)

# 2) 注册成交回调
function on_trade(Ptrade::Cptr{cTrade}, user_data::Ptr{Cvoid})::Cvoid
    trade    = unsafe_load(Ptrade)
    symbol   = unsafe_string(convert(Ptr{UInt8}, Ptrade.symbol))
    order_id = unsafe_string(convert(Ptr{UInt8}, Ptrade.order_id))
    OrderManager.om_handle_trade_hft(trade)      # 直接把 isbits 值传给下游 C 接口
    nothing
end
on_trade_c = @cfunction(on_trade, Cvoid, (Cptr{cTrade}, Ptr{Cvoid}))
HFTCTP.td_set_trade_report_callback(on_trade_c)
```

往 C 侧**写入**配置时同样是构造完整结构体后整体传过去（节选自 [ema.jl `order_manager_manual`](../../ema.jl)）：

```julia
account = FinancialStruct.cAccountFundtable(
    run_id               = str_to_carray_memcpy(run_id,     Val(64)),
    account_id           = str_to_carray_memcpy(account_id, Val(64)),
    account_type         = 2,
    currency             = 0,
    account_start_cash   = 100_000_000 * 10_000,
    account_cash         = 100_000_000 * 10_000,
    account_start_equity = 100_000_000 * 10_000,
    account_equity       = 100_000_000 * 10_000,
    # ...其它字段
)
OrderManager.om_set_account_fund_config(account)   # 直接按值传入
```

### 读取 HDB 二进制文件

HDB 文件中每条记录均为某个 `*_HDB` 结构体的紧凑布局，可这样按记录读取：

```julia
using FinancialStruct

# 直接对 CBinding 生成的类型用 read(io, T)：CBinding 已重载 Base.read
# 见 CBinding/src/aggregates.jl:25
const T_BAR = FinancialStruct.SecurityKdata     # 即 c"struct t_SecurityKdata_HDB"

open("xxx.dat", "r") do io
    while !eof(io)
        bar = read(io, T_BAR)
        println("date=", bar.date, " close=", bar.close)
    end
end
```

也可遍历集合常量批量处理多种结构：

```julia
for T in FinancialStruct.marketdata
    @info "行情结构" name=string(T) size=sizeof(T)
end
```

### 常用 API 速查

| 操作 | 方法 |
|---|---|
| 获取结构体大小 | `sizeof(FinancialStruct.cOrder)` |
| 零初始化构造 | `FinancialStruct.cOrder()` |
| 构造并初始化部分字段 | `FinancialStruct.cOrder(volume=Int32(1), price=UInt64(0))` |
| 基于已有值"复制+更新" | `FinancialStruct.cOrder(old; volume=Int32(2))` |
| 把 String 打包给 char 字段 | `str_to_carray_memcpy(s, Val(N))`（项目通用工具） |
| 从二进制流读取一条 | `read(io, FinancialStruct.cOrder)` |
| 从指针拷贝出值 | `unsafe_load(Ptr{FinancialStruct.cOrder}(p))` 或 `unsafe_load(cptr)` |
| 读取 char 字段 → String | `unsafe_string(convert(Ptr{UInt8}, cptr.field))` |
| primitive 字段读取 | `order.field_name` |
| 数组字段读取 | `order.ask_price[1]`（CBinding `Carray` 支持 `getindex`） |
| 枚举常量访问 | `c"OrderStatus_New"`（需 `using CBinding`）；或直接用整数字面量 `2` |
| C 回调签名 | `@cfunction(fn, Cvoid, (Cptr{cTrade}, Ptr{Cvoid}))` |
| 遍历分类结构集合 | `for T in FinancialStruct.marketdata; …; end` |

### 不可变性总结

`cOrder` / `cTrade` 等所有 `c<Name>` 类型都继承自 `CBinding.Caggregate`，是**不可变 isbits 类型**。这是 C 互操作的必要约束（结构体值要能直接传给 `ccall`、能 `bitcast`、能 `unsafe_load`），并且在 CBinding 的当前实现里**不存在任何"原地修改字段"的可用入口**（包括 `Cptr.field = val` 对 primitive 字段也会报 `Unexpected type ... in store! function`）。

唯一的"修改"语义就是基于已有值构造新值：

| 目标 | ✅ 正确写法 |
|---|---|
| 全新订单 | `o = cOrder(volume=…, price=…, …)` |
| 把已有订单 volume 翻倍 | `o2 = cOrder(o; volume = o.volume * 2)` |
| 累加 `filled_volume` | `o = cOrder(o; filled_volume = o.filled_volume + add)` |
| 改 char 字段 | `o = cOrder(o; symbol = str_to_carray_memcpy("新代码", Val(32)))` |

如果业务逻辑确实需要频繁 mutate，请在 Julia 端用普通的 `mutable struct` 暂存可变状态，只在最后一刻通过 kwargs 构造一个 `cXxx` 用于跨语言传递。

### 适用场景

- **量化交易客户端**：与 C/C++ 行情 / 交易 SDK 直接互通，零拷贝传递 `Order` / `Trade` 等数据；
- **历史数据回放**：按 HDB `*_HDB` 结构 mmap 或读取行情存储文件做回测；
- **风控 / 订单管理**：基于 `om_data_types.h` 定义的 `OmTrade` / `OmOrder` / `PositionUnit` / `Fundtable` 等实现持仓单元化管理与盈亏核算；
- **跨语言对账**：与同一套 C 头文件定义的 Python / C++ / Go 端结构二进制兼容，便于对账与序列化。

### 注意事项

1. 所有结构均使用 `#pragma pack(push, 1)`，**1 字节对齐**；不要在 Julia 端假设 4/8 字节对齐。
2. CBinding 生成的结构体是**不可变 isbits 类型**：`order.field = val`、`Ref(order)[].field = val`、`Cptr{cOrder}(p).field = val`（对 primitive 字段）**全部都会报错**。修改方式见上文「不可变性总结」一节——本质上只有"基于已有值构造新值"一条路。
3. char 数组字段（如 `symbol`、`order_id`）必须用 `str_to_carray_memcpy(s, Val(N))` 这类工具打包成 `Carray{Int8,N}` 后再传给构造函数；`N` 要严格等于头文件里的长度宏。
4. `cFu*` 系列（如 `cFuOrder`、`cFuTrade`、`cFuPosition`）相对普通版本将价格字段由 `uint64_t` 改为 `int64_t`（允许负值，如基差），并在末尾新增 `oper_date` 归属交易日字段。
5. `Account*` 系列结构（如 `AccountPositionUnit`、`AccountFundtable`）相对策略级结构**去除 `strategy_id` 字段**，作为账户级跨策略汇总维度。
6. 修改 `deps/include/*.h` 后，需要重启 Julia 进程并重新 `using FinancialStruct`，CBinding 才会重新解析头文件。
7. 头文件中的 `union`（如 `TickByTickData.data`）在 Julia 端按最大成员尺寸映射，访问时需根据 `type` 字段判断实际成员。

---

## 结构体分类

结构体根据来源分为以下几大类：

- [行情数据相关结构体（md_def.h）](#行情数据相关结构体)
- [交易相关结构体（trade_def.h）](#交易相关结构体)
- [订单管理相关结构体（om_data_types.h）](#订单管理相关结构体)
- [扩展行情盘口结构体（tb_lib_def.h）](#扩展行情盘口结构体)
- [CTP 接口结构体（ThostFtdcUserApiStruct.h）](#ctp-接口结构体)
- [HDB K线数据结构体（src/struct/bar.jl）](#hdb-k线数据结构体)
- [HDB 基础信息结构体（src/struct/baseinfo.jl）](#hdb-基础信息结构体)
- [HDB 基本面数据结构体（src/struct/fundmentals.jl）](#hdb-基本面数据结构体)
- [HDB 港股数据结构体（src/struct/hkdata.jl）](#hdb-港股数据结构体)
- [HDB 市场行情数据结构体（src/struct/marketdata.jl）](#hdb-市场行情数据结构体)
- [HDB 静态信息结构体（src/struct/staticinfo.jl）](#hdb-静态信息结构体)
- [HDB 中证指数数据结构体（src/struct/zzzsdata.jl）](#hdb-中证指数数据结构体)
- [HDB 通用元信息结构体（FinancialStruct.jl）](#hdb-通用元信息结构体)

> 价格类字段普遍以"扩大 10000 倍"或"扩大 100000 倍"的整数存储；时间字段通常按 `YYYYMMDD` 或 `HHMMSSmmm`/`HHMMSSmmmuuu` 格式编码。

---

## 行情数据相关结构体

> 来源：[deps/include/md_def.h](../../deps/include/md_def.h)

### SecurityTickData — 证券tick数据

| 字段 | 类型 | 含义 |
|---|---|---|
| symbol | char[12] | 证券代码（带交易所代码） |
| time | int32_t | 时间(HHMMSSmmm) |
| status | int32_t | 状态 |
| pre_close | uint32_t | 前收盘价 |
| open | uint32_t | 开盘价 |
| high | uint32_t | 最高价 |
| low | uint32_t | 最低价 |
| match | uint32_t | 最新价 |
| ask_price[10] | uint32_t | 申卖价 |
| ask_vol[10] | uint32_t | 申卖量 |
| bid_price[10] | uint32_t | 申买价 |
| bid_vol[10] | uint32_t | 申买量 |
| num_trades | uint32_t | 成交笔数 |
| volume | int64_t | 成交总量 |
| turnover | int64_t | 成交总金额 |
| total_bid_vol | int64_t | 委托买入总量 |
| total_ask_vol | int64_t | 委托卖出总量 |
| weighted_avg_bid_price | uint32_t | 加权平均委买价格 |
| weighted_avg_ask_price | uint32_t | 加权平均委卖价格 |
| iopv | int32_t | IOPV净值估值 |
| yield_to_maturity | int32_t | 到期收益率 |
| high_limited | uint32_t | 涨停价 |
| low_limited | uint32_t | 跌停价 |
| prefix[4] | char | 证券信息前缀 |
| syl1 | int32_t | 市盈率1（股票：价格/上年每股利润，债券：每百元应计利息） |
| syl2 | int32_t | 市盈率2（股票：价格/本年每股利润，债券：到期收益率，基金：每百份的IOPV或净值，权证：溢价率） |
| sd2 | int32_t | 升跌2（对比上一笔） |
| trading_phase_code[8] | char | 交易状态代码（上交所与深交所字段含义不同） |
| pre_iopv | int32_t | 基金T-1日收盘时刻IOPV（仅标的为基金时有效） |

### IndexTickData — 指数Tick数据

| 字段 | 类型 | 含义 |
|---|---|---|
| symbol | char[12] | 证券代码（带交易所代码） |
| time | int32_t | 时间(HHMMSSmmm) |
| open | int32_t | 今开盘指数 |
| high | int32_t | 最高指数 |
| low | int32_t | 最低指数 |
| match | int32_t | 最新指数 |
| volume | int64_t | 参与计算相应指数的交易数量 |
| turnover | int64_t | 参与计算相应指数的成交金额 |
| pre_close | int32_t | 前收盘指数 |

### FuturesTickData — 期货tick数据

| 字段 | 类型 | 含义 |
|---|---|---|
| symbol | char[24] | 证券代码（带交易所代码） |
| time | int32_t | 时间(HHMMSSmmm) |
| status | int32_t | 状态 |
| pre_open_interest | int64_t | 昨持仓 |
| pre_close | int64_t | 昨收盘价 |
| pre_settle_price | int64_t | 昨结算价 |
| open | int64_t | 开盘价 |
| high | int64_t | 最高价 |
| low | int64_t | 最低价 |
| match | int64_t | 最新价 |
| volume | int64_t | 成交总量 |
| turnover | int64_t | 成交总金额 |
| open_interest | int64_t | 持仓总量 |
| close | int64_t | 今收盘 |
| settle_price | int64_t | 今结算价 |
| high_limited | int64_t | 涨停价 |
| low_limited | int64_t | 跌停价 |
| pre_delta | int32_t | 昨虚实度 |
| curr_delta | int32_t | 今虚实度 |
| ask_price[5] | int64_t | 申卖价 |
| ask_vol[5] | uint32_t | 申卖量 |
| bid_price[5] | int64_t | 申买价 |
| bid_vol[5] | uint32_t | 申买量 |
| trading_status | char | 交易状态 |

### OptionsTickData — 期权tick数据

| 字段 | 类型 | 含义 |
|---|---|---|
| symbol | char[24] | 证券代码（带交易所代码） |
| data_timestamp | int32_t | 时间戳 HHMMSSmmm |
| pre_settle_price | int64_t | 昨日结算价（4位小数） |
| settle_price | int64_t | 今日结算价（4位小数） |
| open | int64_t | 开盘价 |
| high | int64_t | 最高价 |
| low | int64_t | 最低价 |
| match | int64_t | 现价 |
| auction_price | int64_t | 波动性中断参考价（4位小数） |
| auction_qty | int64_t | 波动性中断集合竞价虚拟匹配量 |
| total_long_position | int64_t | 当前合约未平仓数量 |
| bid_vol[5] | int64_t | 申买量 |
| bid_price[5] | int64_t | 申买价 |
| ask_vol[5] | int64_t | 申卖量 |
| ask_price[5] | int64_t | 申卖价 |
| volume | int64_t | 成交总量 |
| turnover | int64_t | 成交总金额（2位小数） |
| trading_phase_code[8] | char | 成交阶段代码 |
| transact_time_only[12] | char | 最近询价时间（格式HH:MM:SS.000） |
| num_trades | int64_t | 成交笔数 |
| buy_avg_price | int64_t | 买入加权平均价 |
| buy_volume_trade | int64_t | 买入汇总成交量 |
| sell_avg_price | int64_t | 卖出加权平均价 |
| sell_volume_trade | int64_t | 卖出汇总成交量 |

### SecurityKdata — 证券K线数据

| 字段 | 类型 | 含义 |
|---|---|---|
| symbol | char[24] | 证券代码（带交易所代码） |
| date | uint32_t | 日期 YYYYMMDD |
| time | int32_t | 时间（北京时间） HHMMSS |
| pre_close | int64_t | 前收盘价（单位：1/100分） |
| open | int64_t | 开盘价（单位：1/100分） |
| high | int64_t | 最高价（单位：1/100分） |
| low | int64_t | 最低价（单位：1/100分） |
| close | int64_t | 收盘价（单位：1/100分） |
| volume | int64_t | 分钟内成交量（单位：股/手等） |
| turnover | int64_t | 分钟内成交额（单位：元） |
| open_interest | int64_t | 累计持仓总量 |
| pre_settle_price | int64_t | 前结算价（单位：1/100分） |
| settle_price | int64_t | 结算价（单位：1/100分） |

### CodeInfo — 代码基本信息

| 字段 | 类型 | 含义 |
|---|---|---|
| symbol | char[24] | 证券代码（带交易所代码） |
| sec_type | int32_t | 代码类型，1：股票，2：期货，3：期权 |
| sec_name | char[24] | 代码中文名称（utf8编码） |
| date | uint32_t | 日期 YYYYMMDD |
| high_limited | uint32_t | 涨停价（扩大10000倍） |
| low_limited | uint32_t | 跌停价（扩大10000倍） |
| multiplier | int32_t | 合约乘数（扩大10000倍） |
| margin_ratio | int32_t | 保证金比率（扩大10000倍） |
| price_tick | int32_t | 价格变更单位（扩大10000倍） |
| capital | int64_t | 流通股本数 |
| cap_change_date | uint32_t | 股本变动日期 |
| trade_date_in | uint32_t | 上市日期YYYYMMDD |
| trade_date_out | uint32_t | 退市日期YYYYMMDD |
| is_halt | uint8_t | 是否停牌（1：停牌，0：正常交易） |
| margin_unit | uint32_t | 单位保证金（仅期权有效） |
| margin_ratio_param1 | int32_t | 保证金计算比例参数一（仅期权有效） |
| margin_ratio_param2 | int32_t | 保证金计算比例参数二（仅期权有效） |

### FuCodeInfo — 期货代码基本信息（含手续费）

| 字段 | 类型 | 含义 |
|---|---|---|
| symbol | char[24] | 证券代码（带交易所代码） |
| sec_type | int32_t | 代码类型，1：股票，2：期货，3：期权 |
| sec_name | char[24] | 代码中文名称（utf8编码） |
| date | uint32_t | 日期 YYYYMMDD |
| high_limited | uint32_t | 涨停价（扩大10000倍） |
| low_limited | uint32_t | 跌停价（扩大10000倍） |
| multiplier | int32_t | 合约乘数 |
| margin_ratio | int32_t | 保证金比率（扩大10000倍） |
| price_tick | int32_t | 价格变更单位（扩大10000倍） |
| capital | int64_t | 流通股本数；获取期货当天codeinfo时表示是否支持大额单边（1支持，0不支持） |
| cap_change_date | uint32_t | 股本变动日期 |
| trade_date_in | uint32_t | 上市日期YYYYMMDD |
| trade_date_out | uint32_t | 退市日期YYYYMMDD |
| is_halt | uint8_t | 是否停牌（1：停牌，0：正常交易） |
| margin_unit | uint32_t | 单位保证金（扩大10000倍） |
| margin_ratio_param1 | int32_t | 多头保证金率（扩大10000倍） |
| margin_ratio_param2 | int32_t | 空头保证金率（扩大10000倍） |
| close_pre_commission_ratio | int32_t | 平昨仓手续费比例（扩大100000倍） |
| close_pre_commission | int32_t | 平昨仓手续费（单位：元/手，扩大100000倍） |
| close_today_commission_ratio | int32_t | 平今仓手续费比例（扩大100000倍） |
| close_today_commission | int32_t | 平今仓手续费（单位：元/手，扩大100000倍） |
| open_commission_ratio | int32_t | 开仓手续费比例（扩大100000倍） |
| open_commission | int32_t | 开仓手续费（单位：元/手，扩大100000倍） |

### TradeDate — 交易日期数据

| 字段 | 类型 | 含义 |
|---|---|---|
| utc_time | int64_t | 交易日utc时间 |
| date | uint32_t | 交易日时间YYYYMMDD |

### QxData — 权息数据

| 字段 | 类型 | 含义 |
|---|---|---|
| symbol | char[12] | 证券代码（带交易所代码） |
| date | int32_t | 除权除息日期 YYYYMMDD |
| bonus_ratio | int32_t | 送股比例（扩大10000倍） |
| dividend | int32_t | 红利（扩大10000倍） |
| allot_ratio | int32_t | 配股比例（扩大10000倍） |
| allot_price | int32_t | 配股价（扩大10000倍） |
| add_ratio | int32_t | 增发比例（扩大10000倍） |
| add_price | int32_t | 增发价（扩大10000倍） |
| factor | int32_t | 折算系数（一般用于基金） |

### TickByTickEntrust — 沪深逐笔委托行情数据

| 字段 | 类型 | 含义 |
|---|---|---|
| channel_no | int32_t | 频道代码 |
| side | char | '1':买; '2':卖; 'G':借入; 'F':出借 |
| ord_type | char | SZ订单类别（'1'市价/'2'限价/'U'本方最优）；SH订单类别（'A'增加/'D'删除） |
| res[2] | char | 预留字段 |
| seq | int64_t | 委托序号（在同一channel_no内唯一，从1开始连续） |
| price | int64_t | 委托价格（扩大10000倍） |
| qty | int64_t | SZ委托数量 / SH委托剩余量 |
| order_no | int64_t | SH逐笔委托原始委托号 |
| order_index | int64_t | SH逐笔委托序号 |

### TickByTickTrade — 沪深逐笔成交行情数据

| 字段 | 类型 | 含义 |
|---|---|---|
| channel_no | int32_t | 频道代码 |
| trade_flag | char | SH内外盘标识（'B'主动买/'S'主动卖/'N'未知）；SZ成交标识（'4'撤/'F'成交） |
| res[3] | char | 预留字段 |
| seq | int64_t | 成交序号（在同一channel_no内唯一，从1开始连续） |
| price | int64_t | 成交价格（扩大10000倍） |
| qty | int64_t | 成交量 |
| money | int64_t | 成交金额（扩大10000倍） |
| bid_no | int64_t | 买方订单号 |
| ask_no | int64_t | 卖方订单号 |

### TickByTickData — 沪深逐笔行情数据

| 字段 | 类型 | 含义 |
|---|---|---|
| symbol | char[12] | 证券代码（带交易所代码） |
| type | char | 委托:'0'，成交:'1' |
| res[3] | char | 预留字段 |
| data_time | int64_t | 委托时间 or 成交时间 |
| data | union | 联合体：`entrust`（TickByTickEntrust）或 `trade`（TickByTickTrade） |

### OrderQueueItemData — 委托队列数据项

| 字段 | 类型 | 含义 |
|---|---|---|
| time | int32_t | 委托时间(HHMMSSmmm) |
| side | int32_t | 买卖方向（'B': Bid，'S': Ask） |
| price | int32_t | 委托价格（扩大10000倍） |
| order_num | int32_t | 委托数量 |
| item_num | int32_t | 委托明细数量（最大200个） |
| volume[200] | int32_t | 委托明细 |

### OrderQueueData — 委托队列数据

| 字段 | 类型 | 含义 |
|---|---|---|
| symbol | char[12] | 证券代码（带交易所代码） |
| res[4] | char | 预留字段 |
| item[2] | OrderQueueItemData | 2档委托队列明细数据 |

### DateUpdateData — 市场日期更新消息

| 字段 | 类型 | 含义 |
|---|---|---|
| market | char[8] | 市场 |
| date | int32_t | 日期 YYYYMMDD |

---

## 交易相关结构体

> 来源：[deps/include/trade_def.h](../../deps/include/trade_def.h)

### Order — 订单数据类型

| 字段 | 类型 | 含义 |
|---|---|---|
| strategy_id | char[32] | 策略id |
| run_id | char[32] | 策略运行id（对应回测/模拟/实盘的一次运行） |
| order_id | char[32] | 后台系统生成的内部订单id |
| cl_order_id | char[32] | 订单的客户方id |
| symbol | char[32] | 交易标的（市场.证券ID或市场.合约ID） |
| account_id | char[64] | 用户资金账户id |
| account_type | int16_t | 用户资金账户类型 |
| date | int32_t | 订单创建日期 YYYYMMDD |
| trade_seqno | int32_t | 交易序号（批次号） |
| order_status | int16_t | 订单状态（OrderStatus） |
| order_type | int16_t | 订单类型（OrderType） |
| side | int16_t | 买/卖（OrderSide） |
| credit_type | int16_t | 信用类型（CreditType） |
| volume | int32_t | 订单数量 |
| price | uint64_t | 订单委托价（扩大10000倍） |
| filled_volume | int32_t | 累计已完成数量 |
| filled_turnover | uint64_t | 累计已完成金额（扩大10000倍） |
| filled_price | uint64_t | 成交均价（扩大10000倍） |
| filled_market_value | int64_t | 成交合约价值（扩大10000倍） |
| margin_ratio | int32_t | 保证金比率（扩大10000倍） |
| marketdata_time | int64_t | 触发订单的行情时间（微秒，HHMMSSmmmuuu） |
| create_time | int64_t | 订单创建时间（微秒） |
| update_time | int64_t | 订单更新时间（微秒） |
| finish_time | int64_t | 订单完成时间（微秒） |
| cancel_flag | int16_t | 撤单标识（CancelFlag） |
| cancel_volume | int32_t | 撤单量 |
| cancel_cnt | int32_t | 撤单次数 |
| order_fee | int64_t | 费用（扩大10000倍） |
| hedge_flag | int32_t | 组合投机套保标志（期货） |
| comb_id | char[32] | 组合投机套保编号（期货） |
| plate | char[4] | 期权交易板块 |
| err_code | int32_t | 订单委托错误码 |
| err_msg | char[128] | 订单委托错误消息 |

### FuOrder — 兼容期货的订单数据类型

字段与 `Order` 基本一致，差异如下：
- `price` 由 `uint64_t` 改为 `int64_t`
- `filled_price` 由 `uint64_t` 改为 `int64_t`
- 末尾新增 `oper_date`（int32_t，归属交易日）

### OrderReq — 批量下单订单请求类型

| 字段 | 类型 | 含义 |
|---|---|---|
| order_id | char[32] | 后台系统生成的内部订单id（接口返回时填上） |
| cl_order_id | char[32] | 订单的客户方id |
| symbol | char[32] | 交易标的 |
| order_type | int16_t | 订单类型 |
| side | int16_t | 买/卖 |
| volume | int32_t | 订单数量 |
| price | uint64_t | 订单委托价（限价单使用，扩大10000倍） |
| hedge_flag | int16_t | 期货投机/套利/套保标志 |
| ext_info | char[128] | 扩展信息（key1=v1&key2=v2，支持comb_id、plate） |

### FuOrderReq — 期货批量下单订单请求类型

与 `OrderReq` 一致，仅 `price` 由 `uint64_t` 改为 `int64_t`。

### CancelReq — 撤单请求类型

| 字段 | 类型 | 含义 |
|---|---|---|
| orig_order_id | char[32] | 后台系统生成的订单id |
| cl_order_id | char[32] | 订单的客户方id |
| symbol | char[32] | 交易标的 |
| order_type | int16_t | 订单类型 |
| side | int16_t | 买/卖 |
| volume | int32_t | 订单数量 |
| price | uint64_t | 订单委托价（扩大10000倍） |
| hedge_flag | int16_t | 期货投机/套利/套保标志 |
| ext_info | char[128] | 扩展信息 |

### Trade — 成交数据类型

| 字段 | 类型 | 含义 |
|---|---|---|
| strategy_id | char[32] | 策略ID |
| run_id | char[32] | 策略运行id |
| order_id | char[32] | 内部订单id |
| cl_order_id | char[32] | 客户方订单id |
| symbol | char[32] | 交易标的 |
| account_id | char[64] | 用户资金账户id |
| account_type | int16_t | 资金账户类型 |
| date | int32_t | 成交日期 YYYYMMDD |
| trade_seqno | int32_t | 交易序号 |
| side | int16_t | 买/卖（OrderSide） |
| order_type | int16_t | 订单类型 |
| exec_type | int16_t | 成交回报类型 |
| exec_id | char[32] | 成交回报编号 |
| volume | int32_t | 成交数量 |
| price | uint64_t | 成交价格（扩大10000倍） |
| turnover | uint64_t | 成交金额（扩大10000倍） |
| market_value | int64_t | 成交合约市值（扩大10000倍） |
| order_price | uint64_t | 委托价格（扩大10000倍） |
| order_volume | int32_t | 委托数量 |
| transact_time | int64_t | 成交时间（HHMMSSmmmuuu） |

### FuTrade — 期货成交数据类型

字段与 `Trade` 基本一致，差异如下：
- `price` 由 `uint64_t` 改为 `int64_t`
- `order_price` 由 `uint64_t` 改为 `int64_t`
- 末尾新增 `oper_date`（int32_t，归属交易日）

### CombActionReq — 组合申请请求（期货组合/拆分）

| 字段 | 类型 | 含义 |
|---|---|---|
| action_id | char[32] | 框架生成的内部组合申请id（接口返回时填上） |
| symbol | char[32] | 组合合约，格式为"市场.组合合约ID" |
| comb_direction | int16_t | 组合方向（参考 CombDirection 定义） |
| side | int16_t | 买/卖方向（OrderSide） |
| volume | int32_t | 组合手数 |
| hedge_flag | int16_t | 投机/套保/套利（HedgeFlag） |
| ext_info | char[128] | 扩展信息（key1=v1&key2=v2，预留） |

### CombAction — 组合申请回报

受理回报与错误回报共用同一结构；`err_code` 非 0 表示错误回报。

| 字段 | 类型 | 含义 |
|---|---|---|
| strategy_id | char[32] | 策略id |
| run_id | char[32] | 策略运行id |
| action_id | char[32] | 框架生成的内部组合申请id |
| symbol | char[32] | 组合合约，格式为"市场.组合合约ID" |
| account_id | char[64] | 用户资金账户id |
| account_type | int16_t | 用户资金账户类型 |
| comb_direction | int16_t | 组合方向（参考 CombDirection 定义） |
| side | int16_t | 买/卖方向（OrderSide） |
| volume | int32_t | 组合手数 |
| action_status | int16_t | 组合申请状态（参考 CombActionStatus 定义） |
| err_code | int32_t | 0=成功/受理，非0=错误回报 |
| err_msg | char[128] | 错误信息 |
| date | int32_t | 日期 YYYYMMDD |
| oper_date | int32_t | 归属交易日 |
| update_time | int64_t | 更新时间（微秒，HHMMSSmmmuuu） |

### Position — 仓位数据类型

| 字段 | 类型 | 含义 |
|---|---|---|
| strategy_id | char[32] | 策略ID |
| run_id | char[32] | 策略运行id |
| account_id | char[64] | 用户资金账户id |
| account_type | int16_t | 资金账户类型 |
| symbol | char[32] | 持仓标的 |
| side | int16_t | 持仓方向（PositionSide） |
| volume | int32_t | 总仓量 |
| avail_volume | int32_t | 可用仓量 |
| frozen_volume | int32_t | 冻结仓量 |
| today_volume | int32_t | 今仓总量 |
| today_frozen_volume | int32_t | 今仓冻结量 |
| today_avail_volume | int32_t | 今仓可用量 |
| yesterday_volume | int32_t | 昨仓总量 |
| yesterday_frozen_volume | int32_t | 昨仓冻结量 |
| yesterday_avail_volume | int32_t | 昨仓可用量 |
| avg_cost | uint64_t | 开仓均价（扩大10000倍） |
| hold_cost | uint64_t | 持仓均价（扩大10000倍） |
| create_day | int32_t | 初始建仓日期 YYYYMMDD |
| update_day | int32_t | 仓位变更日期 YYYYMMDD |
| create_time | int64_t | 初始建仓时间（微秒） |
| update_time | int64_t | 仓位变更时间（微秒） |

### FuPosition — 期货仓位数据类型

字段与 `Position` 一致，仅将 `avg_cost`、`hold_cost` 类型由 `uint64_t` 改为 `int64_t`。

### Indicator — 风险收益指标数据类型

| 字段 | 类型 | 含义 |
|---|---|---|
| run_id | char[32] | 策略运行id |
| date | int32_t | 日期 |
| win_count | int32_t | 盈利次数 |
| lose_count | int32_t | 亏损次数 |
| algorithm_return | double | 策略收益率 |
| annual_algo_return | double | 策略年化收益率 |
| benchmark_return | double | 基准收益率 |
| algorithm_volatility | double | 策略波动率 |
| benchmark_volatility | double | 基准波动率 |
| alpha | double | Alpha值 |
| beta | double | Beta值 |
| sharpe | double | 夏普比率 |
| sortino | double | 索提诺比率 |
| information | double | 信息比率 |
| win_ratio | double | 胜率 |
| day_win_ratio | double | 日胜率 |
| max_drawdown | double | 最大回撤 |

### Cash — 资金数据类型

| 字段 | 类型 | 含义 |
|---|---|---|
| account_id | char[64] | 用户资金账户id |
| account_type | int16_t | 资金账户类型 |
| start_cash | int64_t | 初始资金 |
| cash | int64_t | 当前资金 |
| avail_cash | int64_t | 可用资金 |
| locked_cash | int64_t | 冻结资金 |
| turnover | int64_t | 累计交易额 |
| today_turnover | int64_t | 今日交易额 |
| today_close_value | int64_t | 今日卖出券获取的资金额 |
| update_time | int64_t | 帐户更新时间戳 |

### OrderRsp — 订单委托应答详情

| 字段 | 类型 | 含义 |
|---|---|---|
| order_id | char[32] | 内部订单id |
| cl_order_id | char[32] | 客户方订单id |
| err_code | int32_t | 委托错误码 |
| err_msg | char[128] | 委托错误消息 |

### CancelDetail — 撤单详情

| 字段 | 类型 | 含义 |
|---|---|---|
| order_id | char[32] | 内部订单id |
| cancel_order_id | char[32] | 撤单委托id |
| err_code | int32_t | 撤单错误码 |
| err_msg | char[128] | 撤单错误消息 |

### CreditPayBackRsp — 还款应答详情

| 字段 | 类型 | 含义 |
|---|---|---|
| account_id | char[64] | 用户资金账户id |
| account_type | int16_t | 资金账户类型 |
| filled_back_amt | int64_t | 实际还款金额 |
| err_code | int32_t | 委托错误码 |
| err_msg | char[128] | 委托错误消息 |

### CreditAssetsDetail — 信用资产数据

包含可用自有资金、可取资金、冻结资金、证券市值、总资金、总资产、可用保证金、授信额度、可融资额度、可融券额度、维持担保比例、各类负债、利息费用、融券卖出资金、融资融券浮亏与盈亏折算等。所有金额扩大 10000 倍存储。详细字段参见 [deps/include/trade_def.h](../../deps/include/trade_def.h#L493-L527)。

### CreditFinanceDetail — 融资合约数据

| 字段 | 类型 | 含义 |
|---|---|---|
| account_id | char[32] | 交易账号 |
| account_type | int16_t | 账号类型 |
| symbol | char[32] | 交易标的 |
| name | char[32] | 证券名称 |
| order_id | char[32] | 系统订单id |
| currency_type | int16_t | 货币类型 |
| debt_status | int16_t | 负债现状（0未了结/1已了结） |
| occur_date | int32_t | 合约发生日期 |
| total_balance | int64_t | 合约总金额（扩大10000倍） |
| cur_balance | int64_t | 当前未偿还金额 |
| total_interest_fee | int64_t | 利息费用总金额 |
| cur_interest_fee | int64_t | 未偿还利息费用 |
| interest_rate | int64_t | 利率（扩大10000倍） |
| repayable_balance | int64_t | 可还款金额 |
| f_deal_bal | int64_t | 期初应付融资款余额 |
| f_exp_cet_intr | int64_t | 期初应付负债息费 |
| credit_repay_unfrz | int64_t | 当日归还负债金额 |
| all_fee_unfrz | int64_t | 当日归还负债息费 |
| market | int32_t | 市场 |

### CreditShortsellDetail — 融券合约数据

与 `CreditFinanceDetail` 结构类似，字段含义针对融券，主要新增 `total_qty`、`cur_qty`、`d_stk_bal`、`stk_repay_unfrz`、`end_date` 等数量与到期相关字段，参见 [deps/include/trade_def.h](../../deps/include/trade_def.h#L557-L576)。

---

## 订单管理相关结构体

> 来源：[deps/include/om_data_types.h](../../deps/include/om_data_types.h)
>
> 常用长度宏：`OM_LEN_ID=64`、`OM_LEN_ACCOUNT_ID=64`、`OM_LEN_ERR_MSG=128`、`OM_LEN_CODE=32`、`OM_LEN_PRODUCT=32`、`OM_LEN_SECURITY=64`

### OmTrade — 成交记录结构体（持久化）

主键：`order_id + trade_date + strategy_id + run_id + account_id + account_type + match_seqno`

| 字段 | 类型 | 含义 |
|---|---|---|
| order_id | char[64] | 委托唯一标识 |
| trade_date | int32_t | 成交日期（夜盘填归属日） |
| strategy_id | char[32] | 策略ID |
| run_id | char[64] | 实例ID |
| account_id | char[64] | 资金账户ID |
| account_type | int32_t | 资金账户类型 |
| match_seqno | char[64] | 成交序号（交易所唯一标识） |
| match_type | int32_t | 成交回报类型 |
| code | char[32] | 标的代码或合约代码 |
| product | char[32] | 品种（期货/期权特有） |
| market | int32_t | 市场/交易所 |
| cl_order_id | char[32] | 客户自定义order_id |
| side | int32_t | 买卖方向（OrderSide） |
| volume | int32_t | 成交数量（手） |
| price | int64_t | 成交价格（扩大10000倍，含滑点） |
| filled_turnover | int64_t | 合约价值（扩大10000倍） |
| fee | int64_t | 手续费（扩大10000倍） |
| order_volume | int32_t | 委托量 |
| order_price | int64_t | 委托价（扩大10000倍） |
| slippage | int64_t | 成交滑点（扩大10000倍） |
| date | int32_t | 实际交易日期 |
| transact_time | int32_t | 交易时间 HHMMSSmmm |

### OmOrder — 订单记录结构体（持久化）

主键：`order_id + oper_date + strategy_id + run_id + account_id + account_type`

| 字段 | 类型 | 含义 |
|---|---|---|
| order_id | char[64] | 委托唯一标识 |
| oper_date | int32_t | 委托日期（期货夜盘填归属日，YYYYMMDD） |
| strategy_id | char[32] | 策略ID |
| run_id | char[64] | 实例ID |
| account_id | char[64] | 账户ID |
| account_type | int32_t | 账户类型 |
| cl_order_id | char[32] | 客户自定义order_id |
| date | int32_t | 实际委托日期 |
| market | int32_t | 标的物市场 |
| code | char[32] | 标的代码或合约代码 |
| product | char[32] | 品种（期货期权特有） |
| status | int32_t | 订单状态 |
| order_type | int32_t | 订单类型 |
| side | int32_t | 买卖方向（39/40为期货组合/拆分） |
| margin_ratio | int32_t | 保证金率（扩大10000倍） |
| volume | int32_t | 订单数量 |
| price | int64_t | 订单价格（扩大10000倍） |
| contract_multiply | int32_t | 合约乘数 |
| filled_volume | int32_t | 累计完成量 |
| filled_turnover | int64_t | 累计完成价值 |
| frozen | int64_t | 委托冻结资金 |
| fee | int64_t | 手续费（扩大10000倍） |
| cancel_volume | int32_t | 撤单数量 |
| cancel_flag | int32_t | 撤单标识 |
| marketdata_time | int64_t | 触发订单的行情时间 |
| hedge_flag | int32_t | 组合投机套保标识 |
| create_time | int64_t | 订单创建时间（毫秒） |
| update_time | int64_t | 订单更新时间（毫秒） |
| finish_time | int64_t | 订单完成时间（毫秒） |
| security | char[64] | 证券名称 |
| err_code | int32_t | 订单错误码 |
| err_msg | char[128] | 订单错误原因 |

### ContractStat — 合约持仓统计

按 `run_id + account_id + account_type + strategy_id + code` 维度记录今/昨、多/空的 volume 与 frozen_volume，便于无需遍历持仓单元即可快速查询。详见 [deps/include/om_data_types.h](../../deps/include/om_data_types.h#L87-L105)。

### PositionUnit — 持仓单元（按手）

| 字段 | 类型 | 含义 |
|---|---|---|
| id | int64_t | 主键，插入时填0由DB自增 |
| run_id | char[64] | 实例ID |
| account_id | char[64] | 资金账户ID |
| account_type | int32_t | 资金账户类型 |
| strategy_id | char[32] | 策略ID |
| code | char[32] | 合约代码 |
| order_id | char[64] | 开仓委托ID |
| direction | int32_t | 持仓方向（PositionSide） |
| hold_cost | int64_t | 持仓价格（扩大10000倍，结算日更新） |
| open_date | int32_t | 开仓日期 YYYYMMDD |
| open_time | int32_t | 开仓时间 HHmmSSsss |
| open_price | int64_t | 开仓价格（扩大10000倍） |
| close_order_id | char[64] | 平仓委托ID（未平仓为空） |
| close_price | int64_t | 平仓价（扩大10000倍） |
| close_date | int32_t | 平仓日期 |
| close_time | int32_t | 平仓时间 |
| fee | int64_t | 开/平仓手续费合计（扩大10000倍） |
| margin | int64_t | 保证金（扩大10000倍） |
| pnl | int64_t | 盈亏（扩大10000倍） |
| contract_multiply | int32_t | 合约乘数 |
| hedge_flag | int32_t | 投机套保标识（1=投机/2=套保/3=套利） |

### PositionCloseParam — 批量平仓参数

| 字段 | 类型 | 含义 |
|---|---|---|
| id | int64_t | PositionUnit ID |
| fee | int64_t | 开仓费 + 平仓费（扩大10000倍） |
| pnl | int64_t | 平仓盈亏（扩大10000倍） |

### PositionUnitHis — 持仓单元历史表

字段与 `PositionUnit` 一致，新增 `open_id` 字段关联原持仓 ID；`id` 为自增主键，表示平仓顺序。

### PositionWithOrder — 持仓记录聚合（策略级，非持久化）

由 `PositionUnit` / `PositionUnitHis` 按 `(open_order_id, close_order_id)` 二元组聚合而成，**仅策略级**；非持久化，查询时即时聚合产出（未平部分取自 `position_unit`，已平部分取自 `position_unit_his`）。

| 字段 | 类型 | 含义 |
|---|---|---|
| run_id | char[64] | 实例ID（主键） |
| account_id | char[64] | 账户ID（主键） |
| account_type | int32_t | 账户类型（主键） |
| strategy_id | char[32] | 策略ID（主键） |
| open_order_id | char[64] | 开仓指令的 order_id（主键） |
| close_order_id | char[64] | 平仓指令的 order_id（主键） |
| market | int32_t | 标的物市场 |
| code | char[32] | 标的代码或合约代码 |
| product | char[32] | 品种（期货、期权特有） |
| side | int32_t | 方向（PositionSide：多/空） |
| volume | int32_t | 匹配的持仓数量（手数） |
| hold_cost | int64_t | 持仓成本（扩大10000倍）；未平仓日切后更新为上一日结算价/最新价 |
| avail_volume | int32_t | 可用持仓数量（手数） |
| frozen_volume | int32_t | 冻结持仓数量（手数） |
| is_combination | int32_t | 是否组合开仓（0=否，1=是）；郑商所平仓匹配时先平单腿再平组合 |
| position_type | int32_t | 持仓类型：1=今投机，2=昨投机，3=今套保，4=昨套保，5=普通现货 |
| open_day | int32_t | 开仓归属日期 YYYYMMDD |
| open_time | int32_t | 开仓时间 HHmmSSsss（毫秒） |
| open_price | int64_t | 开仓价格（扩大10000倍） |
| open_volume | int32_t | `open_order_id` 对应的开仓数量（手数） |
| margin_ratio | int32_t | 保证金率（扩大10000倍） |
| margin | int64_t | 保证金（扩大10000倍） |
| close_day | int32_t | 平仓归属日期 YYYYMMDD |
| close_time | int32_t | 平仓时间 HHmmSSsss（毫秒） |
| close_price | int64_t | 平仓价格（扩大10000倍）；当日未平仓时期货填结算价、现货填最新价 |
| close_volume | int32_t | `close_order_id` 对应委托的平仓数量（手数） |
| price_tick | int64_t | 最小价格单位（扩大10000倍） |
| basepoint | int64_t | 盈亏基点（扩大10000倍，已扣手续费）：保本价 |
| isclosed | int32_t | 是否已平仓：0=未平仓，1=普通平仓，2=组合/特殊平仓 |
| fee | int64_t | 开平仓总费用（扩大10000倍）= 开仓费用 + 平仓费用 |
| allots | int32_t | 配送信息：1=配股，2=送股/转赠 |
| contract_multiply | int32_t | 合约乘数 |
| worst_price | int64_t | 持有期间最坏价格（扩大10000倍）：多头填期间最低价、空头填期间最高价，用于最大回撤计算 |
| oper_date | int32_t | 归属日 YYYYMMDD：读 `position_his` 快照时填该日；实时聚合/未持久化时为 0 |

### FeeCodeInfo — 费率与保证金参数

| 字段 | 类型 | 含义 |
|---|---|---|
| code | char[32] | 合约代码（NUL结尾） |
| fee_type | int32_t | 费用类型（1=按金额，2=按手数） |
| open_today | int32_t | 当天开仓费率（×100000） |
| open_preday | int32_t | 长线开仓费率（×100000） |
| close_today | int32_t | 短线平仓费率（×100000） |
| close_preday | int32_t | 长线平仓费率（×100000） |
| margin_long1 | int32_t | 投机多头保证金率 |
| margin_long2 | int32_t | 套保多头保证金率 |
| margin_short1 | int32_t | 投机空头保证金率 |
| margin_short2 | int32_t | 套保空头保证金率 |
| multiply | int32_t | 合约乘数 |
| price_tick | int32_t | 最小价格变动单位 |
| presettleprice | int32_t | 昨结算价 |
| max_margin_side | int32_t | 是否支持大额单边（0/1或枚举） |

### Fundtable — 资金表记录（持久化）

主键：`run_id + account_id + account_type + strategy_id`

| 字段 | 类型 | 含义 |
|---|---|---|
| run_id | char[64] | 实例ID |
| account_id | char[64] | 资金账户ID |
| account_type | int32_t | 资金账户类型 |
| strategy_id | char[32] | 策略ID |
| currency | int32_t | 货币类型 |
| frozen_cash | int64_t | 冻结资金 |
| margin | int64_t | 保证金 |
| fee | int64_t | 手续费 |
| pnl | int64_t | 浮动盈亏 |
| avail_cash | int64_t | 可用资金 |
| start_cash | int64_t | 起始资金 |
| minimum_cash | int64_t | 最低可用资金 |
| equity | int64_t | 总权益 |
| start_equity | int64_t | 起始权益 |
| minimum_equity | int64_t | 最小权益 |

> 所有金额均扩大 10000 倍。

### FundtableHis — 资金表历史快照

字段与 `Fundtable` 一致，新增主键 `oper_date`（int32_t，期货夜盘填归属日 YYYYMMDD）。

### AccountFundtable — 账户级资金表

主键：`run_id + account_id + account_type`。相对 `Fundtable` 去除 `strategy_id`，字段命名前缀为 `account_*`，含 `account_frozen`、`bouns`、`account_pnl`、`account_start_cash`、`account_cash`、`account_mincash`、`account_margin`、`account_start_equity`、`account_equity`、`account_minequity`。

### AccountFundtableHis — 账户级资金表历史快照

与 `AccountFundtable` 一致，新增 `oper_date` 主键。

### AccountPositionUnit — 账户级持仓单元

字段与 `PositionUnit` 一致，**无 `strategy_id` 字段**（账户级跨策略汇总），并新增 `combination_id`（int64_t，0=未参与组合，非0关联 `CombinationUnit.id`）。

### AccountPositionCloseParam — 账户级批量平仓参数

| 字段 | 类型 | 含义 |
|---|---|---|
| id | int64_t | AccountPositionUnit ID |
| fee | int64_t | 开仓费 + 平仓费（扩大10000倍） |
| pnl | int64_t | 平仓盈亏（扩大10000倍） |

### AccountPositionUnitHis — 账户级持仓单元历史表

与 `AccountPositionUnit` 一致，新增 `open_id`（int64_t，关联原持仓ID）。

### AccountPositionWithOrder — 账户级持仓记录聚合（非持久化）

由 `AccountPositionUnit` / `AccountPositionUnitHis` 按 `(open_order_id, close_order_id)` 聚合而成；**账户级**（无 `strategy_id`，跨策略汇总），支持组合（combination）；非持久化即时聚合产出。

字段与 [PositionWithOrder](#positionwithorder--持仓记录聚合策略级非持久化) 基本一致，差异如下：

- **去除** `strategy_id` 字段（账户级跨策略汇总维度）；
- **新增** `combination_id`（int64_t）：组合ID，0=未参与组合；非0=关联 `CombinationUnit.id`（组内首个非0值）；
- `is_combination` 语义为"组内任一手参与组合即 1"。

### CombinationUnit — 组合持仓单元（账户级）

| 字段 | 类型 | 含义 |
|---|---|---|
| id | int64_t | 组合ID（主键） |
| run_id | char[64] | 实例ID |
| account_id | char[64] | 资金账户ID |
| account_type | int32_t | 资金账户类型 |
| order_id | char[64] | 组合委托ID |
| code | char[32] | 组合合约代码 |
| side | int32_t | 组合方向（1=多头/2=空头） |
| position_unit_id_a | int64_t | 第一腿 ID |
| position_unit_id_b | int64_t | 第二腿 ID |
| margin | int64_t | 组合优惠保证金（扩大10000倍） |
| existed_flag | int32_t | 是否存在（0/1） |
| create_time | int64_t | 创建时间（YYYYMMDDHHmmSSsss） |
| break_time | int64_t | 拆分时间（YYYYMMDDHHmmSSsss） |

### CombinationUnitHis — 组合持仓单元历史

字段与 `CombinationUnit` 一致，新增 `combination_id`（原组合ID）与 `oper_date`（结算日期 YYYYMMDD）。

### AccountContractStat — 账户级合约统计

与 `ContractStat` 一致，无 `strategy_id` 字段（账户级跨策略汇总）。

### AccountScopePnlDelta — 账户作用域盈亏变化

| 字段 | 类型 | 含义 |
|---|---|---|
| run_id | char[64] | 实例ID |
| account_id | char[64] | 账户ID |
| account_type | int32_t | 账户类型 |
| delta_pnl | int64_t | 本次浮盈变化（多空合计，×10000）= Σ新pnl − Σ旧pnl |

### ExternalPosition — 外部持仓数据（用于校验）

| 字段 | 类型 | 含义 |
|---|---|---|
| code | char[32] | 合约代码 |
| long_volume | int32_t | 多头持仓数量（正数） |
| short_volume | int32_t | 空头持仓数量（正数） |

---

## 扩展行情盘口结构体

> 来源：[deps/include/tb_lib_def.h](../../deps/include/tb_lib_def.h)；扩展盘口档位 `TB_EXT_LEVELS = 10`

### OnlyTBTickData — 扩展盘口Tick数据

| 字段 | 类型 | 含义 |
|---|---|---|
| ticker | uint32_t | 快照计数器（从0开始递增） |
| build_status | int | 当前撮合状态（0正常，非0异常） |
| is_halt | bool | 是否处于临时停牌 |
| virtual_match | uint32_t | 集合竞价虚拟成交价 |
| virtual_volume | int64_t | 集合竞价虚拟成交量 |
| total_bid_amount | int64_t | 总委托买入金额 |
| total_ask_amount | int64_t | 总委托卖出金额 |
| total_bid_orders | int64_t | 总委托买入笔数 |
| total_ask_orders | int64_t | 总委托卖出笔数 |
| up_limit_vol | int64_t | 涨停价委托量 |
| up_limit_orders | int64_t | 涨停价委托笔数 |
| down_limit_vol | int64_t | 跌停价委托量 |
| down_limit_orders | int64_t | 跌停价委托笔数 |
| ask_orders_num[10] | int | 每个卖盘档位对应的委托数量 |
| bid_orders_num[10] | int | 每个买盘档位对应的委托数量 |
| ask_dists_vol[10] | int64_t | 离开卖一价一段距离的盘口挂单量 |
| bid_dists_vol[10] | int64_t | 离开买一价一段距离的盘口挂单量 |

---

## CTP 接口结构体

> 来源：[deps/include/ThostFtdcUserApiStruct.h](../../deps/include/ThostFtdcUserApiStruct.h)（结构定义）+ [ThostFtdcUserApiDataType.h](../../deps/include/ThostFtdcUserApiDataType.h)（字段类型 typedef）

上期所 CTP 接口共定义 **386** 个 `CThostFtdc*Field` 结构体（用户登录、报单、查询、风控、结算等全套）。模块**已自动解析两个头文件**，但出于 Julia 端命名空间整洁与编译速度考虑，**仅对量化交易常用的核心子集**手工创建了 `cCtp*` 别名（共 33 个，见 [src/FinancialStruct.jl](../../src/FinancialStruct.jl)）。

如需访问尚未创建别名的 CTP 结构体，两种做法：

```julia
# 1) 直接用 c"..." 字符串宏（无需修改源码）
T = c"struct CThostFtdcQryDepthMarketDataField"
sizeof(T)

# 2) 在本模块或外部代码里追加 bitstype 别名
cCtpQryDepthMarketData = bitstype(c"struct CThostFtdcQryDepthMarketDataField")
```

### 命名规则

`CThostFtdc<Name>Field` → `cCtp<Name>`。例如：

| C 结构体 | Julia 别名 |
|---|---|
| `CThostFtdcInputOrderField` | `cCtpInputOrder` |
| `CThostFtdcOrderField` | `cCtpOrder` |
| `CThostFtdcTradeField` | `cCtpTrade` |
| `CThostFtdcDepthMarketDataField` | `cCtpDepthMarketData` |
| `CThostFtdcQryInvestorPositionField` | `cCtpQryInvestorPosition` |

### 字段类型说明

CTP 结构体字段几乎全部是 typedef 别名（如 `TThostFtdcBrokerIDType` = `char[11]`、`TThostFtdcPriceType` = `double`），CBinding 会自动沿 `#include "ThostFtdcUserApiDataType.h"` 解析这些 typedef。Julia 端看到的字段类型与已有 `cOrder` 完全同构：

```julia
# CThostFtdcReqUserLoginField 在 Julia 端的字段
# BrokerID :: Carray{Int8, 11}     # TThostFtdcBrokerIDType
# UserID   :: Carray{Int8, 16}     # TThostFtdcUserIDType
# Password :: Carray{Int8, 41}     # TThostFtdcPasswordType
# ...
req = cCtpReqUserLogin(
    BrokerID = str_to_carray_memcpy("9999", Val(11)),
    UserID   = str_to_carray_memcpy("123456", Val(16)),
    Password = str_to_carray_memcpy("***",    Val(41)),
)
```

### 已注册的 cCtp 别名（33 个）

按用途分组：

**会话/认证**
- `cCtpRspInfo` — 通用应答信息（含错误码与错误消息）
- `cCtpReqUserLogin` / `cCtpRspUserLogin` — 用户登录请求/应答
- `cCtpUserLogout` — 用户登出
- `cCtpReqAuthenticate` / `cCtpRspAuthenticate` — 客户端认证
- `cCtpUserPasswordUpdate` — 用户口令变更
- `cCtpSettlementInfo` / `cCtpSettlementInfoConfirm` — 结算单 / 结算单确认

**委托/撤单**
- `cCtpInputOrder` — 报单录入
- `cCtpInputOrderAction` — 撤单录入
- `cCtpOrder` — 报单回报（实时状态）
- `cCtpOrderAction` — 撤单回报
- `cCtpTrade` — 成交回报

**账户/持仓**
- `cCtpInvestor` — 投资者基本信息
- `cCtpInvestorPosition` — 投资者持仓汇总
- `cCtpInvestorPositionDetail` — 投资者持仓明细（按手）
- `cCtpInvestorPositionCombineDetail` — 组合持仓明细
- `cCtpTradingAccount` — 资金账户

**合约/行情**
- `cCtpInstrument` — 合约
- `cCtpDepthMarketData` — 深度行情
- `cCtpSpecificInstrument` — 订阅合约回报

**查询请求（Qry）**
- `cCtpQryOrder` / `cCtpQryTrade` / `cCtpQryInvestorPosition` / `cCtpQryInvestorPositionDetail`
- `cCtpQryTradingAccount` / `cCtpQryInvestor` / `cCtpQryInstrument` / `cCtpQryDepthMarketData`
- `cCtpQrySettlementInfo` / `cCtpQryInstrumentMarginRate` / `cCtpQryInstrumentCommissionRate`

> 完整 386 个 CTP 结构体的字段定义请直接查阅 [ThostFtdcUserApiStruct.h](../../deps/include/ThostFtdcUserApiStruct.h)；本文档不再逐一列出，避免与上游头文件不同步。

---

## HDB K线数据结构体

> 来源：[src/struct/bar.jl](../../src/struct/bar.jl)；集合：`bar = (SecurityKdata,)`

### SecurityKdata_HDB — HDB证券K线数据

| 字段 | 类型 | 含义 |
|---|---|---|
| date | uint32_t | 日期 YYYYMMDD |
| time | int32_t | 时间 |
| pre_close | int64_t | 前收盘价 |
| open | int64_t | 开盘价 |
| high | int64_t | 最高价 |
| low | int64_t | 最低价 |
| close | int64_t | 收盘价 |
| volume | int64_t | 成交量 |
| turnover | int64_t | 成交额 |
| open_interest | int64_t | 持仓量 |
| pre_settle_price | int64_t | 昨结算价 |
| settle_price | int64_t | 结算价 |

---

## HDB 基础信息结构体

> 来源：[src/struct/baseinfo.jl](../../src/struct/baseinfo.jl)；集合 `baseinfo = (...)` 共 19 个结构体。

### SHProductInfo_HDB — 上交所产品信息

包含 ISIN、UpdateTime、Symbol、EnglishName、UnderlyingSecurityID、MarketType、SecurityType、SecuritySubType、Currency、ParValue（面值）、UnlistedFloatShareQuantity、LastTradeDate、ListDate、SETNo、BuyQtyUnit/SellQtyUnit、QtyLowerLimit/QtyUpperLimit、PrevClosePx、PriceTick、LimitType、LimitUpAbsolute/LimitDownAbsolute、XR/XD、CrdBuyUnderlying/CrdSellUnderlying（融资融券标的）、Status、MarketQtyLowerLimit/MarketQtyUpperLimit、ChineseName、MEMO 等字段，详见 [baseinfo.jl:3-36](../../src/struct/baseinfo.jl#L3-L36)。

### SHOptionInfo_HDB — 上交所期权合约信息

包含 RFStreamID、ContractID、ContractSymbol、UnderlyingSecurityID/Symbol、UnderlyingType、OptionType、CallOrPut、ContractMultiplierUnit、ExercisePrice、StartDate/EndDate/ExerciseDate/DeliveryDate/ExpireDate、UpdateVersion、TotalLongPosition、SecurityClosePx、SettlPrice、UnderlyingPreClosePx、PriceLimitType、DailyPriceUpLimit/DailyPriceDownLimit、MarginUnit、MarginRatioParam1/2、RoundLot、各类 Floor、TickSize、SecurityStatusFlag、AutoSplitDate、UnderlyingSymbolEx 等。详见 [baseinfo.jl:38-74](../../src/struct/baseinfo.jl#L38-L74)。

### SZPStock_HDB / SZStock_HDB / SZFund_HDB / SZBond_HDB / SZWarrant_HDB / SZRepo_HDB / SZOption_HDB / SZReits_HDB — 深交所各类证券基础信息

这 8 个结构体共享一组基础字段（SecurityIDSource、Symbol、SymbolEx、EnglishName、ISIN、UnderlyingSecurityID/Source、ListDate、SecurityType、Currency、QtyUnit、DayTrading、PrevClosePx、SecurityStatus[13]、OutstandingShare、PublicFloatShareQuantity、ParValue、GageFlag、GageRatio、CrdBuyUnderlying、CrdSellUnderlying、PriceCheckMode、PledgeFlag、ContractMultiplier、RegularShare、QualificationFalg、QualificationClass），并按证券类型附加专有字段：

- **SZPStock**：附加 `Interest`、`OfferingFlag`
- **SZStock**：附加 `IndustryClassification`、`PreviousYearProfitPerShare`、`CurrentYearProfitPerShare`、`OfferingFlag`、`Attribute`、`NoProfit`、`WeightedVotingRights`、`IsRegistration`、`IsVIE`
- **SZFund**：附加 `NAV`
- **SZBond**：附加 `CouponRate`、`IssuePrice`、`Interest`、`InterestAccrualDate`、`MaturityDate`、`OfferingFlag`、`SwapFlag`、`PutbackFlag`、`PutbackCancelFlag`
- **SZWarrant**：附加 `ExercisePrice`、`ExerciseRatio`、`ExerciesBeginDate/EndDate`、`CallOrPut`、`DeliveryType`、`ClearingPrice`、`ExerciseType`、`LastTradeDay`
- **SZRepo**：附加 `ExpirationDays`
- **SZOption**：附加 `CallOrPut`、`ListType`、`DeliveryDay/Month`、`DeliveryType`、`ExerciesBeginDate/EndDate`、`ExercisePrice`、`ExerciseType`、`LastTradeDay`、`AdjustTimes`、`ContractUnit`、`PrevClearingPrice`、`ContractPosition`
- **SZReits**：附加 `MaturityDate`

字段详情见 [baseinfo.jl:76-360](../../src/struct/baseinfo.jl#L76-L360)。

### SZTenderer_HDB — 深交所投标人信息

| 字段 | 类型 | 含义 |
|---|---|---|
| TendererID | char[6] | 投标人ID |
| TendererName | char[200] | 投标人名称 |
| OfferingPrice | uint64_t | 发行价 |
| BeginDate | uint32_t | 开始日期 |
| EndDate | uint32_t | 结束日期 |

### RightsIssue_HDB — 配股信息

| 字段 | 类型 | 含义 |
|---|---|---|
| SecurityIDSource | char[4] | 证券来源 |
| Symbol | char[160] | 证券代码 |
| SymbolEx | char[160] | 扩展证券代码 |
| EnglishName | char[40] | 英文名称 |
| UnderlyingSecurityID | char[8] | 基础证券ID |
| UnderlyingSecurityIDSource | char[4] | 基础证券来源 |
| Price | uint64_t | 配股价格 |
| Unit | uint64_t | 配股单位 |

### DerivativeAuction_HDB — 衍生品集合竞价参数

包括 BuyQtyUpperLimit/SellQtyUpperLimit、MarketBuy/SellQtyUpperLimit、QuoteBuy/SellQtyUpperLimit、BuyQtyUnit/SellQtyUnit、PriceTick、PriceUpperLimit/LowerLimit、LastSellMargin、SellMargin、MarginRatioParam1/2、MarketMakerFlag 等字段，详见 [baseinfo.jl:381-399](../../src/struct/baseinfo.jl#L381-L399)。

### CashAuction_HDB — 现货集合竞价参数

包括各类 BuyQty/SellQty 上限、单位、Market 类型上限、PriceTick、MarketMakerFlag 等。详见 [baseinfo.jl:401-413](../../src/struct/baseinfo.jl#L401-L413)。

### PriceLimitSetting_HDB — 价格限制设置

包含 Type、HasPriceLimit、ReferPriceType、LimitType、LimitUpRate/DownRate、LimitUpAbsolute/DownAbsolute、HasAuctionLimit、AuctionLimitType、AuctionReferPriceType、AuctionUpDownRate、AuctionUpDownAbsolute。

### SZCombinationStrategy_HDB — 深交所组合策略

| 字段 | 类型 | 含义 |
|---|---|---|
| StrategyID | char[8] | 策略ID |
| AutoSplitDay | uint32_t | 自动拆分日期 |

### TInstrument_HDB — 期货合约信息

| 字段 | 类型 | 含义 |
|---|---|---|
| InstrumentName | char[40] | 合约名称 |
| UpLimitPrice | uint64_t | 涨停价 |
| LowLimitPrice | uint64_t | 跌停价 |
| VolumeMultiple | int64_t | 合约乘数 |
| PriceTick | int64_t | 价格变动单位 |
| OpenDate | uint32_t | 上市日 |
| ExpireDate | uint32_t | 到期日 |
| ExchangeID | char[9] | 交易所ID |
| LongMarginRatio | int64_t | 多头保证金率 |
| ShortMarginRatio | int64_t | 空头保证金率 |

### BJNQXX_HDB — 北交所证券信息

包含 ShortName、EnglishName、BaseCode、ISINCode、TradeUnit、Industry、Currency、ShareVal、Capital、NonRestCap、LastYearProfit/CurYearProfit、HandlingRate/StampDutyRate/TransferRate、ListDate/StartDate/EndDate、MaxNumber/MinNumber/BuyNumber/SellNumber、PriceTick、FirstLimintParam/FollowLimitParam/LimitParamKind、HighLimitPrc/LowLimitPrc、BlockHighLimit/BlockLowLimit、CompoFlag、EquiRatio、TradeStatus、SecLevel、TradeType、MarketMakerNum、HaltFlag、QxFlag、NetVoteFlag、OtherBusStatus、UpdateTime。详见 [baseinfo.jl:449-491](../../src/struct/baseinfo.jl#L449-L491)。

### SecurityInfo_HDB — 通用证券信息

包含 ISIN_CODE、EXCHMARKET_CODE、EXCHMARKET_ANN_CODE、INFO_NAME_NATIONAL、INFO_FULLNAME/ENG、SECURITYCLASS/SUBCLASS、SECURITYTYPE、INFO_COUNTRYCODE、INFO_EXCHANGE/ENG、INFO_CODE、INFO_COMPCODE、SECURITY_STATUS、CRNCY_CODE、INFO_CURPAR、MIN_PRC_CHG_UNIT、INFO_UNITPERLOT、INFO_LISTDATE/DELISTDATE、INFO_LISTPRICE、INFO_TYPECODE、CONTRACT_ID、INFO_LISTBOARDNAME、TRADING_STATUS。详见 [baseinfo.jl:493-520](../../src/struct/baseinfo.jl#L493-L520)。

---

## HDB 基本面数据结构体

> 来源：[src/struct/fundmentals.jl](../../src/struct/fundmentals.jl)；集合：`fundmentals = (QxData,)`

### QxData_HDB — HDB权息数据

| 字段 | 类型 | 含义 |
|---|---|---|
| date | int32_t | 除权除息日期 |
| bonus_ratio | int32_t | 送股比例（扩大10000倍） |
| dividend | int32_t | 红利 |
| allot_ratio | int32_t | 配股比例 |
| allot_price | int32_t | 配股价 |
| add_ratio | int32_t | 增发比例 |
| add_price | int32_t | 增发价 |
| factor | int32_t | 折算系数 |

---

## HDB 港股数据结构体

> 来源：[src/struct/hkdata.jl](../../src/struct/hkdata.jl)；集合 `hkdata = (HKSecurityTick, HKIndexTick, HKTradeTicker, HKCodeInfo)`

### HKSecurityTick_HDB — 港股证券Tick

| 字段 | 类型 | 含义 |
|---|---|---|
| security_code | uint32_t | 证券代码 |
| time | int64_t | 时间 |
| pre_close_price | int32_t | 前收盘价 |
| price | int32_t | 现价 |
| shares_traded | uint64_t | 成交股数 |
| turnover | int64_t | 成交金额 |
| high_price/low_price/last_price | int32_t | 最高/最低/最新价 |
| vwap | int32_t | 成交量加权平均价 |
| price_b[10] / quantity_b[10] | int32_t / uint64_t | 买盘十档价/量 |
| price_s[10] / quantity_s[10] | int32_t / uint64_t | 卖盘十档价/量 |
| open_price | int32_t | 开盘价 |

### HKIndexTick_HDB — 港股指数Tick

包含 index_code、index_status、index_time、index_value、net_chg_prev_day、high_value/low_value、eas_value、index_turnover、open_value/close_value、previous_ses_close、index_volume、net_chg_prev_day_pct、exception、filler。详见 [hkdata.jl:21-38](../../src/struct/hkdata.jl#L21-L38)。

### HKTradeTicker_HDB — 港股逐笔成交

| 字段 | 类型 | 含义 |
|---|---|---|
| security_code | uint32_t | 证券代码 |
| ticker_id | uint32_t | 成交编号 |
| price | int32_t | 成交价 |
| agg_quantity | uint64_t | 累计成交量 |
| trade_time | uint64_t | 成交时间 |
| trd_type | int16_t | 成交类型 |
| trd_cancel_flag | char | 撤单标志 |
| filler | char | 填充 |

### HKCodeInfo_HDB — 港股代码信息

包含 security_code、market_code、isin_code、instrument_type、product_type、spread_table_code、security_short_name、currency_code、gccs_name/gb_name、lot_size、pre_close_price、vcm_flag、short_sell_flag、cas_flag、ccas_flag、dummy_security_flag、stamp_duty_flag、listing_date/delisting_date、free_text、pos_flag、pos_upper_limit/pos_lower_limit、efn_flag、accrued_interest、coupon_rate、conversion_ratio、strike_price1/2、maturity_date、call_put_flag、style 等字段（含若干填充字节）。详见 [hkdata.jl:51-93](../../src/struct/hkdata.jl#L51-L93)。

---

## HDB 市场行情数据结构体

> 来源：[src/struct/marketdata.jl](../../src/struct/marketdata.jl)；集合 `marketdata = (SecurityTick, IndexTick, FuturesTick, OptionsTick, SHStepTrade, SZStepTrade, SZStepOrder, OrderQueueItem, SZOptionsTick, SHStepOrder, FPSHStepTrade, CodeInfo)`

### SecurityTick_HDB — HDB证券Tick

与 `SecurityTickData` 字段一致，但**不包含** `symbol` 字段（HDB 内部已通过索引区分标的），其余字段含义参见 [SecurityTickData](#securitytickdata--证券tick数据)。

### IndexTick_HDB — HDB指数Tick

不含 symbol，其余同 `IndexTickData`。

### FuturesTick_HDB — HDB期货Tick

不含 symbol，其余同 `FuturesTickData`。

### OptionsTick_HDB — HDB期权Tick

不含 symbol、num_trades、buy_*、sell_* 等扩展字段，其余同 `OptionsTickData`。

### SHStepTrade_HDB — 上交所逐笔成交

| 字段 | 类型 | 含义 |
|---|---|---|
| trade_index | int32_t | 成交序号 |
| trade_channel | int32_t | 频道号 |
| trade_time | int32_t | 成交时间 |
| trade_price | int32_t | 成交价 |
| trade_qty | int64_t | 成交量 |
| trade_money | int64_t | 成交金额 |
| trade_buy_no | int64_t | 买方订单号 |
| trade_sell_no | int64_t | 卖方订单号 |
| bs_flag | char | 内外盘标识 |
| res[3] | char | 预留 |
| biz_index | int64_t | 业务序号 |

### SZStepTrade_HDB — 深交所逐笔成交

| 字段 | 类型 | 含义 |
|---|---|---|
| channel_no | uint16_t | 频道号 |
| appl_seq_num | int64_t | 业务序号 |
| md_stream_id | char[3] | 行情流ID |
| bid_appl_seq_num | int64_t | 买方业务序号 |
| offer_appl_seq_num | int64_t | 卖方业务序号 |
| security_id | char[8] | 证券代码 |
| security_id_source | char[4] | 证券来源 |
| last_px | int64_t | 成交价 |
| last_qty | int64_t | 成交量 |
| exec_type | char | 成交类型 |
| transact_time | int64_t | 成交时间 |

### SZStepOrder_HDB — 深交所逐笔委托

| 字段 | 类型 | 含义 |
|---|---|---|
| channel_no | uint16_t | 频道号 |
| appl_seq_num | int64_t | 业务序号 |
| md_stream_id | char[3] | 行情流ID |
| security_id | char[8] | 证券代码 |
| security_id_source | char[4] | 证券来源 |
| price | int64_t | 委托价 |
| order_qty | int64_t | 委托数量 |
| side | char | 买卖方向 |
| transact_time | int64_t | 委托时间 |
| ord_type | char | 订单类型 |

### OrderQueueItem_HDB — HDB委托队列

字段与 `OrderQueueItemData` 一致：time、side、price、order_num、item_num、volume[200]。

### SZOptionsTick_HDB — 深交所期权Tick

包含 time、channel_no、md_stream_id、security_id、security_id_source、trading_phase_code、prev_close_px、num_trades、total_volume_trade/value_trade、last_price、open/high/low_price、buy_avg_price/buy_volume_trade、sell_avg_price/sell_volume_trade、offer_price/qty[10]、bid_price/qty[10]、price_upper_limit/lower_limit、contract_position 等字段。详见 [marketdata.jl:142-168](../../src/struct/marketdata.jl#L142-L168)。

### SHStepOrder_HDB — 上交所逐笔委托

| 字段 | 类型 | 含义 |
|---|---|---|
| order_index | int32_t | 委托序号 |
| order_channel | int32_t | 频道号 |
| order_time | int32_t | 委托时间 |
| order_type | char | 委托类型 |
| res1[3] | char | 预留 |
| order_no | int64_t | 委托号 |
| order_price | int32_t | 委托价 |
| balance | int64_t | 委托余量 |
| order_bs_flag | char | 买卖标志 |
| res2[3] | char | 预留 |
| biz_index | int64_t | 业务序号 |

### FPSHStepTrade_HDB — 上交所FP逐笔成交

字段与 `SHStepTrade_HDB` 完全一致（不同行情源的同构体）。

### CodeInfo_HDB — HDB代码基本信息

字段与 [CodeInfo](#codeinfo--代码基本信息) 一致，但**不含** `symbol`，并在末尾新增 `sec_name_ext[61]`（扩展中文名称）。详见 [marketdata.jl:198-216](../../src/struct/marketdata.jl#L198-L216)。

---

## HDB 静态信息结构体

> 来源：[src/struct/staticinfo.jl](../../src/struct/staticinfo.jl)；集合 `staticinfo = (Component, ETFInfo)`

### Component_HDB — ETF成分股信息

| 字段 | 类型 | 含义 |
|---|---|---|
| underlying_symbol | char[20] | 成分代码 |
| underlying_symbol_source | char[4] | 代码来源 |
| security_name | char[64] | 证券名称 |
| substitute_flag | char | 替代标志 |
| component_qty | int64_t | 成分数量 |
| premium_ratio | int32_t | 溢价比率 |
| discount_ratio | int32_t | 折价比率 |
| creation_cash_substitute | int64_t | 申购替代金额 |
| redemption_cash_substitute | int64_t | 赎回替代金额 |
| substitution_cash_amount | int64_t | 替代金额 |
| bs_open | char | 开放标志 |
| reserved[30] | char | 预留 |

### ETFInfo_HDB — ETF基础信息

包含 version、etf_name、fund_management_company、underlying_index、creation_redemption_unit、estimate_cash_component、max_cash_ratio、publish/creation/redemption 标志、sz_record_num、total_record_num、trading_day/pre_trading_day、cash_component、nav_per_cu、nav、dividend_per_cu、creation_limit/redemption_limit（及 peruser、net、net peruser 等组合）、all_cash_flag/amount/premium_rate/discount_rate、rtgs_flag、reserved。详见 [staticinfo.jl:18-51](../../src/struct/staticinfo.jl#L18-L51)。

---

## HDB 中证指数数据结构体

> 来源：[src/struct/zzzsdata.jl](../../src/struct/zzzsdata.jl)；集合 `zzzsdata = (ZZZSIndexTick, ZZZSEtfIopv, ZSCodeInfo)`

### ZZZSIndexTick_HDB — 中证实时指数

| 字段 | 类型 | 含义 |
|---|---|---|
| record_type | uint16_t | 记录类型 |
| time | int32_t | 时间 |
| stand_by[5] | char | 预留 |
| index_code[7] | char | 指数代码 |
| index_referred[21] | char | 指数简称 |
| market_code | uint16_t | 市场代码 |
| realtime_index | uint64_t | 实时指数值 |
| open_value_of_today | uint64_t | 今开盘值 |
| maximum_of_day | uint64_t | 当日最高 |
| minimum_of_day | uint64_t | 当日最低 |
| close_value_of_today | uint64_t | 今收盘值 |
| close_value_of_yesterday | uint64_t | 昨收盘值 |
| rise_and_fall | int64_t | 涨跌 |
| rise_and_fall_range | int64_t | 涨跌幅 |
| match_volume | uint64_t | 成交量 |
| match_amount | uint64_t | 成交金额 |
| exchange_rate | uint64_t | 汇率 |
| money_type | uint16_t | 货币类型 |
| index_serial | uint32_t | 指数序列号 |
| close_value_of_today2/3 | uint64_t | 今收盘值2/3 |

### ZZZSEtfIopv_HDB — 中证ETF IOPV

| 字段 | 类型 | 含义 |
|---|---|---|
| record_type | uint16_t | 记录类型 |
| time | int32_t | 时间 |
| stand_by[5] | char | 预留 |
| stock_code[9] | char | 证券代码 |
| stock_name[9] | char | 证券名称 |
| market_code | uint16_t | 市场代码 |
| iopv | int64_t | IOPV值 |

### ZSCodeInfo_HDB — 中证代码信息

字段与 `ZZZSEtfIopv_HDB` 完全一致（同构）。详见 [zzzsdata.jl:37-45](../../src/struct/zzzsdata.jl#L37-L45)。

---

## HDB 通用元信息结构体

> 来源：[src/FinancialStruct.jl](../../src/FinancialStruct.jl)
>
> 相关常量：`HDB_MAX_FILE_TYPE_NUM=64`、`HDB_MAX_DATA_FIELD_NUM=512`、`HDB_MAX_DATA_OPT_FIELD_NUM=63`、`HDB_MAX_SYMBOL_SIZE=24`、`HDB_MAX_TYPENANE_SIZE=32`、`HDB_MAX_FIELDNANE_SIZE=32`、`HDB_MAX_ITEMDATA_SIZE=64*1024`、`HDB_MAX_CLIENT_FILE_READ_SIZE=250*1024`

### HDataField — HDB字段定义

| 字段 | 类型 | 含义 |
|---|---|---|
| field_name | NTuple{32, Cchar} | 字段名 |
| field_type | Cint | 字段类型（参见 `HFieldType` 枚举） |
| field_op | Cint | 字段编码操作（参见 `HFieldEncodeOp`） |
| field_size | Cint | 字段大小 |
| field_flags | Cint | 字段标志（参见 `HFieldFlag`） |

### HDataType — HDB数据类型定义

| 字段 | 类型 | 含义 |
|---|---|---|
| type | NTuple{32, Cchar} | 类型名 |
| field_count | Cint | 字段数量 |
| fields | NTuple{512, HDataField} | 字段定义数组 |
| data_size | Cint | 数据大小 |

### HDataItem — HDB数据项

| 字段 | 类型 | 含义 |
|---|---|---|
| symbol | NTuple{24, Cchar} | 证券代码 |
| index | Cint | 索引 |
| trading_day | Cint | 交易日 |
| local_time | Int64 | 本地时间 |
| time_point_seq_no | Cint | 时间序号 |
| type_id | Cint | 类型ID |
| data | Ptr{UInt8} | 数据指针 |

### HCodeInfo — HDB代码信息

| 字段 | 类型 | 含义 |
|---|---|---|
| symbol | NTuple{24, Cchar} | 证券代码 |
| index | Cint | 索引 |
| total_items_num | Cint | 总记录数 |
| type_items_nums | NTuple{64, Cint} | 各类型记录数 |
| data | Ptr{UInt8} | 数据指针 |

---

## 枚举与错误码

模块内还定义了以下枚举（详见 [src/FinancialStruct.jl:80-85](../../src/FinancialStruct.jl#L80-L85)）：

- `HRetCode`：返回码（`OK=0`，`NotFound=-1`，`Corruption=-2`，`NotSupported=-3`，`InvalidArgument=-4`，`IOError=-5`，`Incomplete=-6`，`Full=-8`，`NotEnoughMemory=-9`，`EOF=-10`，`InvalidTime=-11`，`NetTimeout=-12`，`ConnError=-13`，`AuthError=-14`，`NetIOError=-15`，`ExceedLimit=-16`）
- `HFileAccFlag`：文件访问标志（`ReadOnly`、`ReadWrite`、`GenerateIndexFile`）
- `HFieldType`：字段类型（Char/Short/Int/Long/Float/Double 及其无符号、数组、零结尾等变体共20种，定义顺序对应 `type_tuple` / `ctype_tuple`）
- `HFieldEncodeOp`：字段编码操作（`Raw`、`ValueCompress`、`ValueIncCompress`）
- `HFieldFlag`：字段标志（`Optional=1`）
- `HClientCreateFileOption`：客户端创建文件选项（`FailOnExist`、`ClearCurrData`、`AppendData`）

trade_def.h 中另定义了以下交易类枚举（用于 Order/Trade/Position 等字段）：

- `OrderStatus`：订单状态（PendingNew=1 … Rejected=9）
- `OrderType`：订单类型（LMT、BOC、BOP、B5TC、B5TL、IOC、AON、ALMT、ELMT、OLMT）
- `OrderSide`：买卖方向（含期货今/昨平、融资融券、ETF申赎、回购、配股等共 38 项）
- `PositionSide`：持仓方向（Long=1、Short=2、Short_Covered=3）
- `TradeReportType`：成交回报类型（Normal、Cancel、Abolish、InsideCancel、CancelAbolish）
- `AccountType`：账户类型（Stock、Futures、Options、Margin、SHHK_Stock、SZHK_Stock、ExtFund、Gold、Forex）
- `CancelFlag`：撤单标识（False=1、True=2）
- `CreditType`：交易类型（Normal、CashLoan、SecurityLoan）
- `HedgeFlag`：投机套保（Placeholder=0、Speculation=1、Hedge=2、Arbitrage=3）

行情侧 md_def.h 中定义：

- `MDTickType`：行情数据类型（SecurityTick、IndexTick、FuturesTick、OptionsTick、TickByTick、OrderQueue、SecurityKdata）
- `MarketId`：交易市场（Null、SH、SZ、CFFEX、CZCE、DCE、SHFE、HK、SGE、CFETS、SHOP、SZOP）

---

## 集合常量

`src/struct/*.jl` 中每个文件末尾定义了同名集合，方便批量遍历/注册：

| 集合名 | 包含结构体 |
|---|---|
| `bar` | `SecurityKdata` |
| `baseinfo` | `SHProductInfo, SHOptionInfo, SZPStock, SZStock, SZFund, SZBond, SZWarrant, SZRepo, SZOption, SZReits, SZTenderer, RightsIssue, DerivativeAuction, CashAuction, PriceLimitSetting, SZCombinationStrategy, TInstrument, BJNQXX, SecurityInfo` |
| `fundmentals` | `QxData` |
| `hkdata` | `HKSecurityTick, HKIndexTick, HKTradeTicker, HKCodeInfo` |
| `marketdata` | `SecurityTick, IndexTick, FuturesTick, OptionsTick, SHStepTrade, SZStepTrade, SZStepOrder, OrderQueueItem, SZOptionsTick, SHStepOrder, FPSHStepTrade, CodeInfo` |
| `staticinfo` | `Component, ETFInfo` |
| `zzzsdata` | `ZZZSIndexTick, ZZZSEtfIopv, ZSCodeInfo` |

---

## 备注

1. 所有 C 结构体均使用 `#pragma pack(push, 1)` 紧凑布局，1 字节对齐，便于与外部二进制存储（HDB）或行情/交易 SDK 直接互操作。
2. 价格类字段统一以扩大 10000 倍（部分手续费扩大 100000 倍）的整数表示，避免浮点精度问题；使用时需除以对应倍数。
3. 期货专用类型（`Fu*` 前缀的 `FuOrder`、`FuTrade`、`FuPosition`、`FuOrderReq`、`FuCodeInfo`）相对普通版本的主要差异在于：将价格相关字段由 `uint64_t` 改为 `int64_t`（允许负值，如基差），并新增 `oper_date` 归属交易日字段。
4. 账户级结构（`Account*` 前缀）相对策略级结构通常**去除 `strategy_id` 字段**，作为跨策略汇总维度，并在持仓单元类型上附加组合相关字段（`combination_id`）。
5. CTP 结构体（`cCtp*` 前缀）原始定义在 [ThostFtdcUserApiStruct.h](../../deps/include/ThostFtdcUserApiStruct.h)，使用上期所标准 typedef（`TThostFtdc*Type`）作为字段类型，CBinding 会沿 `#include` 链自动解析；不需要在 Julia 端额外做 typedef 还原。当前仅注册了 33 个常用别名，其余按需 `bitstype(c"struct CThostFtdcXxxField")` 添加。
