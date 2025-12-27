---
title: "Example Post Title2"
date: 2025-12-24
section: "hobbies"
categories: ["3d"]
description: "This is a simple example post for demonstration purposes."
reading_time: 2
---

## Learned

- .vh 파일을 사용하면 verilog header 파일로 clk cycle이나, array size 등 전역에서 필요한 정보를 선언한다. include로 사용하고 한 번만 선언되도록 한다.
- TB에서 @posedge(clk) 가져가면서 = 으로 assign하면 그게 top dut module과 race condition을 만들 수 있으니 꼭 clk에 sync할거면 non-blocking을 사용하도록 한다.
- //region //end region 을 활용해서 너무 긴 line의 wire declaration을 주석처리할 수 있다.

## Tips

### 1. gtkwave for MAC(recent OS)

If you are using recent MAC OS, there can be some conflict to open the wave file via the CLI.

It is recommended to install gtkwave with below command line.

```bash
brew install --HEAD randomplum/gtkwave/gtkwave
```

### 2. task 문법 - verilog

task 문법을 사용하면 TB를 좀 더 깔끔하고 modular하게 작성할 수 있다.

다만 주의할 점은 `top dut module과 race condition`을 주의해서 task 실행 뒤의 cycle과 그 cycle이 posedge인지 negedge인지를 계산해야된다. -> non-blocking 사용

```verilog
task check_outputs_vectorwise(input integer current_cycle, input integer offset);
    integer row_idx;
    integer start_port;
    integer target_col;
    reg [25:0] golden_val;
    begin
        start_port = current_cycle - 16;
        target_col = current_cycle - 16;

        for (row_idx = 0; row_idx < 16; row_idx = row_idx + 1) begin
            golden_val = mem_ref[offset*256 + (row_idx * 16) + target_col];

            if (io_outputC[start_port + row_idx] !== golden_val) begin
                $display("[ERROR] Cycle %d | Col %d, Row %d (Port %d): Exp %h, Got %h", 
                        current_cycle, target_col, row_idx, start_port + row_idx, golden_val, io_outputC[start_port + row_idx]);
            end else begin
                // $display("[PASS] Port %d OK", start_port + row_idx);
            end
        end
    end
endtask
```

### 3. for loop - synchronize using @posedge

When using for loop to test the DUT with various vectors, it is recommended to synchronize using @posedge.

Rather than using `#delay`, when using `@posedge` `@negedge` sign makes it more robust.

