class Cell
    attr_accessor :xpos
    attr_accessor :ypos
    attr_accessor :type
    def initialize(xpos,ypos,type)
        @xpos=xpos
        @ypos=ypos
        @type=type
    end
end

class Chess
    attr_accessor :board
    def initialize
        @board=[]
        display_board
        init_board
    end

    def init_board
        for i in 0..7
            @board[i]=[]
            for j in 0..7
                @board[i].push(Cell.new(i,j,1)) 
            end
        end
    end

    def display_board
        puts "\n"
        puts "    a  b  c  d  e  f  g  h"
        puts "  --------------------------"
        puts "8 | *  *  *  *  *  *  *  * | 8"
        puts "7 | *  *  *  *  *  *  *  * | 7"
        puts "6 | *  *  *  *  *  *  *  * | 6"
        puts "5 | *  *  *  *  *  *  *  * | 5"
        puts "4 | *  *  *  *  *  *  *  * | 4"
        puts "3 | *  *  *  *  *  *  *  * | 3"
        puts "2 | *  *  *  *  *  *  *  * | 2"
        puts "1 | *  *  *  *  *  *  *  * | 1"
        puts "  --------------------------"
        puts "    a  b  c  d  e  f  g  h"
        puts "\n"
    end
end

game=Chess.new
