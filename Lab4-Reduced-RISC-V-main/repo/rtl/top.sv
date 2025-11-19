module top #(
    DATA_WIDTH = 32
) (
    input   logic clk,
    input   logic rst,
    output  logic [DATA_WIDTH-1:0] a0    
);
    assign a0 = 32'd5;

    //pc module
    logic [DATA_WIDTH-1:0]  PC;

    pc_module pc(
        .clk(clk),
        .rst(rst),
        .PCsrc(PCsrc),
        .immOp(immOp),

        .PC(PC)
    )

    //instrmem
    logic [DATA_WIDTH-1:0] instr;

    instrmem instrmem(
        .A(PC),

        .RD(instr)
    )

    //sign extension    
    logic [DATA_WIDTH-1:0]  immOp;

    extend extend(
        .instr(instr),
        .ImmSrc(ImmSrc),

        .immOp(immOp)
    )

    //control unit
    logic EQ;

    logic RegWrite;
    logic ALUctrl;
    logic ALUsrc;
    logic ImmSrc;
    logic PCsrc;

    controlunit controlunit(
        .instr(instr),
        .EQ(EQ)

        .RegWrite(RegWrite),
        .ALUctrl(ALUctrl),
        .ALUsrc(ALUsrc),
        .ImmSrc(ImmSrc),
        .PCsrc(PCsrc)
    )

    //reg file
    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [4:0] rd;

    always_comb begin
        case(instr[6:0])
            7'b0000011: begin
                assign rd = instr[11:7];
            end
            7'b0100011: begin
                assign rs2 = instr[24:20];
            end
            7'b1100011: begin
                assign rs2 = instr[24:20];
            end
            default begin
                assign rs1 = instr[19:15];
                assign rs2 = 5'b0;
                assign rd = b'b0;
            end
    end

    regfile regfile(
        .clk(clk),
        .AD1(rs1),
        .AD2(rs2),
        .AD3(rd),
        .WE3(RegWrite),
        .WD3(ALUout),

        .RD1(ALUop1),
        .RD2(regOp2),
        .a0(a0)
    )

   

endmodule
