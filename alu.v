// basic_alu.v

module basic_alu (
    input [7:0] A,             // First 8-bit Operand
    input [7:0] B,             // Second 8-bit Operand
    input [2:0] ALU_Sel,       // 3-bit Operation Selector
    output reg [7:0] Result,   // 8-bit Output Result
    output reg Zero,           // Zero Flag (Result is 0)
    output reg Carry           // Carry/Borrow Flag (For ADD/SUB)
);

// --- Operation Codes ---
// We use 3 bits to select up to 8 operations.
parameter SEL_ADD = 3'b000;
parameter SEL_SUB = 3'b001;
parameter SEL_AND = 3'b010;
parameter SEL_OR  = 3'b011;
parameter SEL_NOT = 3'b100; // NOTE: NOT only uses operand A

// Internal signals to calculate results with extra bits for carry/borrow
wire [8:0] sum_result;
wire [7:0] not_b_result;

// Adder/Subtractor Core (Uses B's two's complement for subtraction)
assign sum_result = A + (ALU_Sel == SEL_SUB ? (~B + 1'b1) : B) + 1'b0; // 9 bits for carry out

// NOT operation on B (only for internal calculation)
assign not_b_result = ~B;

// --- Main ALU Logic ---
always @(*) begin
    // Default assignment
    Result = 8'hXX; // Assign unknown state to clearly see when operation is selected
    Carry  = 1'b0;
    
    // Select the operation
    case (ALU_Sel)
        SEL_ADD: begin
            Result = sum_result[7:0]; // Sum result (8 bits)
            Carry  = sum_result[8];   // Carry flag is the 9th bit
        end
        
        SEL_SUB: begin
            Result = sum_result[7:0]; // Subtraction result
            // Borrow flag: 9th bit of A + (~B + 1)
            // Carry-out from the adder is the inverse of the borrow-in
            Carry  = sum_result[8];
        end
        
        SEL_AND: begin
            Result = A & B;
            Carry  = 1'b0;
        end
        
        SEL_OR: begin
            Result = A | B;
            Carry  = 1'b0;
        end
        
        SEL_NOT: begin
            // NOTE: We perform NOT on the second operand, B
            Result = not_b_result;
            Carry  = 1'b0;
        end
        
        default: begin
            Result = 8'h00; // Default or NOP result
            Carry  = 1'b0;
        end
    endcase
    
    // Zero Flag calculation (Combinatorial)
    Zero = (Result == 8'h00) ? 1'b1 : 1'b0;
end

endmodule
