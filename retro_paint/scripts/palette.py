#RRGGBBSS
#
#S S  C    C
#
#-|--|----|-------
#1 2  4    8
def to_hex_color(rr:list,gg:list,bb:list,ss:list):
    
    red = (ss[0] + 2**ss[1] + 4**rr[0]+ 8**rr[1])/15 * 255
    green = (ss[0] + 2**ss[1] + 4**gg[0]+ 8**gg[1])/15 * 255
    blue = (ss[0] + 2**ss[1] + 4**bb[0]+ 8**bb[1])/15 * 255
    hex_red = format(int(red),'X')
    hex_green = format(int(green),'X')
    hex_blue = format(int(blue),'X')
    color = hex_red + hex_green + hex_blue
    return color

def decimal_to_color(decimal):
    bin_ = f'{decimal:08b}'
    rr = [int(bin_[0]),int(bin_[1])]
    gg = [int(bin_[2]),int(bin_[3])]
    bb = [int(bin_[4]),int(bin_[5])]
    ss = [int(bin_[7]),int(bin_[6])]
    return rr,gg,bb,ss

html = "<html><body>"
colors1 = []
for i in range(0,256):

    color = to_hex_color(*decimal_to_color(i))
    colors.append(color)
    div = f"<div class='color' style='width:20;height:20; background-color:#{color}'></div>"
    print(div)