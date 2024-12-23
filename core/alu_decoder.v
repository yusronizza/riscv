module ALUDecoder (
    input       [2:0]   ALUOp,
    input       [2:0]   funct3,
    input               funct75,
    input               OPCode5,
    output  reg [3:0]   ALUControl
);

/* 
 * ALU Control List
 * RISCV32I has 10 type of ALU Instruction
*/
localparam ALU_ADD  = 4'b0000;
localparam ALU_SUB  = 4'b0001;
localparam ALU_AND  = 4'b0010;
localparam ALU_OR   = 4'b0011;
localparam ALU_SLT  = 4'b0100;
localparam ALU_SLL  = 4'b0101;
localparam ALU_SLTU = 4'b0110;
localparam ALU_XOR  = 4'b0111;
localparam ALU_SRL  = 4'b1000;
localparam ALU_SRA  = 4'b1001;

wire op5funct75 = {OPCode5, funct75};

always @(ALUOp or funct3 or funct75 or OPCode5) begin
    case (ALUOp)
        2'b00: 
            ALUControl <= ALU_ADD;
        2'b01: 
            ALUControl <= ALU_SUB;
        2'b10: begin
            case (funct3)
                3'b000: 
                begin
                    if (op5funct75 == 2'b11) begin
                        ALUControl <= ALU_SUB;
                    end
                    else begin
                        ALUControl <= ALU_ADD;
                    end
                end
                3'b001: 
                    ALUControl <= ALU_SLL;
                3'b010: 
                    ALUControl <= ALU_SLT;
                3'b011: 
                    ALUControl <= ALU_SLTU;
                3'b100: 
                    ALUControl <= ALU_XOR;
                3'b101: begin
                    case (op5funct75)
                        2'b00: 
                            ALUControl <= ALU_SRL; 
                        2'b01: 
                            ALUControl <= ALU_SRA;
                        2'b10: 
                            ALUControl <= ALU_SRL;
                        2'b11: 
                            ALUControl <= ALU_SRA;
                        default: 
                            ALUControl <= ALU_ADD;
                    endcase
                end
                3'b110: 
                    ALUControl <= ALU_OR;
                3'b111: 
                    ALUControl <= ALU_AND;
                default: 
                    ALUControl <= ALU_ADD;
            endcase
        end
        default: 
            ALUControl <= ALU_ADD;
    endcase
end

endmodule