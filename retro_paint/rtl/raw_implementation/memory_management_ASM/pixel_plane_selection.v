module pixel_plane_selection (
    input [7:0] px_data,
    input [1:0] selection,
    output reg R,
    output reg G,
    output reg B
);
  always @(*) begin
    case (selection)
      2'b00: begin
        R = px_data[0];
        G = px_data[0];
        B = px_data[0];
      end
      2'b01: begin
        R = px_data[1];
        G = px_data[1];
        B = px_data[1];
      end
      2'b10: begin
        R = px_data[6];
        G = px_data[4];
        B = px_data[2];
      end
      2'b11: begin
        R = px_data[7];
        G = px_data[5];
        B = px_data[3];
      end
    endcase
  end
endmodule
