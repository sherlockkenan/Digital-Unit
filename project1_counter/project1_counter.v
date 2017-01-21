// ==============================================================
//
// This stopwatch is just to test the work of LED and KEY on DE1-SOC board.
// The counter is designed by a series mode. / asynchronous mode. 即异步进位
// use "=" to give value to hour_counter_high and so on. 异步操作/阻塞赋值方式
//
// 3 key: key_reset/系统复位, key_start_pause/暂停计时, key_display_stop/暂停显示
//
// ==============================================================
module stopwatch_01(clk,key_reset,key_start_pause,key_display_stop,
// 时钟输入 + 3 个按键；按键按下为 0 。板上利用施密特触发器做了一定消抖，效果待测试。
hex0,hex1,hex2,hex3,hex4,hex5,
// 板上的 6 个 7 段数码管，每个数码管有 7 位控制信号。
led0,led1,led2,led3 );
// LED 发光二极管指示灯，用于指示/测试程序按键状态，若需要，可增加。 高电平亮。
input clk,key_reset,key_start_pause,key_display_stop;
output [6:0] hex0,hex1,hex2,hex3,hex4,hex5;
output led0,led1,led2,led3;
reg led0,led1,led2,led3;
reg display_work=0;
// 显示刷新，即显示寄存器的值 实时 更新为 计数寄存器 的值。
reg counter_work=0;
// 计数（计时）工作 状态，由按键 “计时/暂停” 控制。
parameter DELAY_TIME = 10000000;
// 定义一个常量参数。 10000000 ->200ms； 
// 定义 6 个显示数据（变量）寄存器：
reg [3:0] minute_display_high;
reg [3:0] minute_display_low;
reg [3:0] second_display_high;
reg [3:0] second_display_low;
reg [3:0] msecond_display_high;
reg [3:0] msecond_display_low;

// 定义 6 个计时数据（变量）寄存器：
reg [3:0] minute_counter_high;
reg [3:0] minute_counter_low;
reg [3:0] second_counter_high;
reg [3:0] second_counter_low;
reg [3:0] msecond_counter_high;
reg [3:0] msecond_counter_low;
reg [31:0] counter_50M; // 计时用计数器， 每个 50MHz 的 clock 为 20ns。
// DE1-SOC 板上有 4 个时钟， 都为 50MHz，所以需要 500000 次 20ns 之后，才是 10ms。
wire reset_1_time; // 消抖动用状态寄存器 -- for reset KEY
reg [31:0] counter_reset; // 按键状态时间计数器
wire start_1_time; //消抖动用状态寄存器 -- for counter/pause KEY
reg [31:0] counter_start; //按键状态时间计数器
wire display_1_time; //消抖动用状态寄存器 -- for KEY_display_refresh/pause
reg [31:0] counter_display; //按键状态时间计数器
reg start; // 工作状态寄存器
reg display; // 工作状态寄存器
// sevenseg 模块为 4 位的 BCD 码至 7 段 LED 的译码器，
//下面实例化 6 个 LED 数码管的各自译码器。
reg reset=1;
reg reset_check=1;

sevenseg LED8_minute_display_high ( minute_display_high, hex5 );
sevenseg LED8_minute_display_low ( minute_display_low, hex4 );
sevenseg LED8_second_display_high( second_display_high, hex3 );
sevenseg LED8_second_display_low ( second_display_low, hex2 );
sevenseg LED8_msecond_display_high( msecond_display_high, hex1 );
sevenseg LED8_msecond_display_low ( msecond_display_low, hex0 ); 

debounce RESET_KEY(clk,key_reset,reset_1_time);
debounce START_PAUSE_KEY(clk,key_start_pause,start_1_time);
debounce DISPLAY_STOP_KEY(clk,key_display_stop,display_1_time);


always@(negedge reset_1_time)
begin
      reset=~reset;
end


always@(negedge start_1_time)
begin
      counter_work=~counter_work;
end

always@(negedge display_1_time)
begin
      display_work=~display_work;
end

integer i=0;

always @ (posedge clk) //每一个时钟上升沿开始触发下面的逻辑
begin
//此处功能代码省略，由同学自行设计。
if (reset==reset_check)
begin
    minute_counter_high=0;
	 minute_counter_low=0;
	 second_counter_high=0;
	 second_counter_low=0;
	 msecond_counter_high=0;
	 msecond_counter_low=0;
	 minute_display_high=minute_counter_high;
	 minute_display_low=minute_counter_low;
	 second_display_high=second_counter_high;
	 second_display_low=second_counter_low;
	 msecond_display_high=msecond_counter_high;
	 msecond_display_low=msecond_counter_low;
    reset_check=~reset_check;
end

if(counter_work)
begin
	i=i+1;
	if(i== DELAY_TIME/20 )
	begin
		i=0;
		msecond_counter_low=msecond_counter_low+1;
		
		if(msecond_counter_low>=10)
		begin 
			 msecond_counter_low=0;
			 msecond_counter_high=msecond_counter_high+1;
		end
		
		if(msecond_counter_high>=10)
		begin 
			 msecond_counter_high=0;
			 second_counter_low=second_counter_low+1;
		end
	
		if(second_counter_low>=10)
		begin 
			 second_counter_low=0;
			 second_counter_high=second_counter_high+1;
		end
		
		if(second_counter_high>=6)
		begin 
			 second_counter_high=0;
			 minute_counter_low=minute_counter_low+1;
		end
		
		if(minute_counter_low>=10)
		begin 
			minute_counter_low=0;
			minute_counter_high= minute_counter_high+1;
		end
		
		
		if(display_work)
		begin 
			minute_display_high=minute_counter_high;
			minute_display_low=minute_counter_low;
			second_display_high=second_counter_high;
			second_display_low=second_counter_low;
			msecond_display_high=msecond_counter_high;
			msecond_display_low=msecond_counter_low;
		 end	
	end
end
end
endmodule

