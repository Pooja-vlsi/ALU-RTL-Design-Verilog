// alu_tb.v (Testbench for basic_alu module)

module alu_tb;

// --- Testbench Signals ---
reg [7:0] A;
reg [7:0] B;
reg [2:0] ALU_Sel;
wire [7:0] Result;
wire Zero;
wire Carry;

// --- Operation Codes (Must match design module) ---
parameter SEL_ADD = 3'b000;
parameter SEL_SUB = 3'b001;
parameter SEL_AND = 3'b010;
parameter SEL_OR  = 3'b011;
parameter SEL_NOT = 3'b100;

// --- Instantiate the ALU Unit Under Test (UUT) ---
basic_alu uut (
    .A(A),
    .B(B),
    .ALU_Sel(ALU_Sel),
    .Result(Result),
    .Zero(Zero),
    .Carry(Carry)
);

// --- Stimulus Generation ---
initial begin
    // 1. WAVEFORM DUMP COMMANDS 
    $dumpfile("dump.vcd"); 
    // Dump all signals (0) in the UUT scope (uut) - SAFEST OPTION
    $dumpvars(0);
    #1; // Wait 1ns for dump initialization
    
    // 2. INITIALIZATION
    A = 8'h00;
    B = 8'h00;
    ALU_Sel = SEL_ADD;
    #10;

    $display("Time | Op | A | B | Result | Zero | Carry");
    $display("-------------------------------------------");

    // Test 1: ADD (10 + 20 = 30)
    A = 8'd10;
    B = 8'd20;
    ALU_Sel = SEL_ADD;
    #10; 
    $display("%4d | ADD | %h | %h | %h | %b | %b", $time, A, B, Result, Zero, Carry);

    // Test 2: ADD (255 + 1 = 0, Carry=1, Zero=1)
    A = 8'hFF; 
    B = 8'h01; 
    ALU_Sel = SEL_ADD;
    #10;
    $display("%4d | ADD | %h | %h | %h | %b | %b", $time, A, B, Result, Zero, Carry);

    // Test 3: SUB (50 - 15 = 35)
    A = 8'd50;
    B = 8'd15;
    ALU_Sel = SEL_SUB;
    #10; 
    $display("%4d | SUB | %h | %h | %h | %b | %b", $time, A, B, Result, Zero, Carry);

    // Test 4: SUB (100 - 100 = 0, Zero=1)
    A = 8'd100;
    B = 8'd100;
    ALU_Sel = SEL_SUB;
    #10; 
    $display("%4d | SUB | %h | %h | %h | %b | %b", $time, A, B, Result, Zero, Carry);

    // Test 5: AND (F0 & 0F = 00)
    A = 8'hF0; 
    B = 8'h0F; 
    ALU_Sel = SEL_AND;
    #10; 
    $display("%4d | AND | %h | %h | %h | %b | %b", $time, A, B, Result, Zero, Carry);

    // Test 6: OR (F0 | 0F = FF)
    A = 8'hF0; 
    B = 8'h0F; 
    ALU_Sel = SEL_OR;
    #10; 
    $display("%4d | OR  | %h | %h | %h | %b | %b", $time, A, B, Result, Zero, Carry);

    // Test 7: NOT (NOT 55 = AA)
    A = 8'hAA; // Ignored operand
    B = 8'h55; 
    ALU_Sel = SEL_NOT;
    #10; 
    $display("%4d | NOT | %h | %h | %h | %b | %b", $time, A, B, Result, Zero, Carry);

    // 3. FINISH SIMULATION
    $finish;
end

endmodule
