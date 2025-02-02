module mainDecoder(
    input   [6:0]           OPCode,
    input   [2:0]           funct3,
    output reg [5:0]        branch,
    output wire             jump,
    output wire             regWrite,
    output wire [2:0]       immSrc,
    output wire             ASrc,
    output wire             BSrc,
    output wire [1:0]       resultSrc,
    output wire             memWrite,
    output wire             PCTargetSrc,
    output wire [1:0]       ALUOp,
    output wire [1:0]       DQM
);


/* 
 * Instruction OPCodes
 * RISC-V has 6 type of Instruction : I, U, S, R, B, J
*/
localparam OPCode_I_LW         = 7'b0000011; // 3
localparam OPCode_I_IMM        = 7'b0010011; // 19
localparam OPCode_U_AUI        = 7'b0010111; // 23 : CS
localparam OPCode_S_STORE      = 7'b0100011; // 35
localparam OPCode_R_TYPE       = 7'b0110011; // 51
localparam OPCode_U_LUI        = 7'b0110111; // 55
localparam OPCode_B_BRANCH     = 7'b1100011; // 99
localparam OPCode_I_JALR       = 7'b1100111; // 103 : CS
localparam OPCode_J_JAL        = 7'b1101111; // 111


/* Branch and Jump signal */ 
assign jump   = (OPCode == OPCode_I_JALR)     ? 1'b1 : 
                (OPCode == OPCode_J_JAL)      ? 1'b1 : 1'b0;

//Branch State
localparam branchBEQ    = 3'b000;
localparam branchBNE    = 3'b001;
localparam branchBLT    = 3'b100;
localparam branchBGE    = 3'b101;
localparam branchBLTU   = 3'b110;
localparam branchBGEU   = 3'b111;

always @* begin
    if (OPCode == OPCode_B_BRANCH) begin
        case (funct3)
            branchBEQ : branch = 6'b100000;
            branchBNE : branch = 6'b010000;
            branchBLT : branch = 6'b001000;
            branchBGE : branch = 6'b000100;
            branchBLTU: branch = 6'b000010;
            branchBGEU: branch = 6'b000001;
            default   : branch = 6'b000000;
        endcase
    end
    else begin
        branch <= 6'b000000;
    end
end

assign memWrite     = (OPCode == OPCode_S_STORE)    ? 1'b1 : 1'b0;

assign PCTargetSrc  = (OPCode == OPCode_B_BRANCH)   ? 1'b1 : 
                      (OPCode == OPCode_J_JAL)      ? 1'b1 : 1'b0;

assign regWrite     = (OPCode == OPCode_S_STORE)    ? 1'b0 :
                      (OPCode == OPCode_B_BRANCH)   ? 1'b0 : 1'b1;

assign resultSrc    = (OPCode == OPCode_I_LW)       ? 2'b01 :
                      (OPCode == OPCode_R_TYPE)     ? 2'b00 :
                      (OPCode == OPCode_I_IMM)      ? 2'b00 :
                      (OPCode == OPCode_U_AUI)      ? 2'b00 :
                      (OPCode == OPCode_U_LUI)      ? 2'b10 :
                      (OPCode == OPCode_J_JAL)      ? 2'b11 :
                      (OPCode == OPCode_I_JALR)     ? 2'b11 : 2'b00 ;

assign ASrc         = (OPCode == OPCode_U_AUI)      ? 1'b0 : 1'b1;

assign BSrc         = (OPCode == OPCode_R_TYPE)     ? 1'b0 :
                      (OPCode == OPCode_B_BRANCH)   ? 1'b0 : 1'b1;

assign immSrc       = (OPCode == OPCode_I_LW)       ? 3'b000 :
                      (OPCode == OPCode_S_STORE)    ? 3'b001 :
                      (OPCode == OPCode_I_IMM)      ? 3'b000 :
                      (OPCode == OPCode_U_AUI)      ? 3'b100 :
                      (OPCode == OPCode_U_LUI)      ? 3'b100 :
                      (OPCode == OPCode_B_BRANCH)   ? 3'b010 :
                      (OPCode == OPCode_I_JALR)     ? 3'b011 :
                      (OPCode == OPCode_J_JAL)      ? 3'b011 : 3'b000;

assign ALUOp        = (OPCode == OPCode_I_LW)       ? 2'b00 :
                      (OPCode == OPCode_S_STORE)    ? 2'b00 :
                      (OPCode == OPCode_R_TYPE)     ? 2'b10 :
                      (OPCode == OPCode_I_IMM)      ? 2'b10 :
                      (OPCode == OPCode_U_AUI)      ? 2'b00 :
                      (OPCode == OPCode_B_BRANCH)   ? 2'b01 :
                      (OPCode == OPCode_I_JALR)     ? 2'b00 : 2'b00;

assign DQM          = (funct3 == 3'b000)            ? 2'b00 :
                      (funct3 == 3'b001)            ? 2'b01 :
                      (funct3 == 3'b010)            ? 2'b10 : 2'b00;

endmodule