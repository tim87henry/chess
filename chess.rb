class Cell
    attr_accessor :xpos
    attr_accessor :ypos
    attr_accessor :type
    attr_accessor :set
    attr_accessor :moves_list
    def initialize(xpos,ypos,type=0,set=0)
        @xpos=xpos
        @ypos=ypos
        @type=type
        @set=set
        @moves_list=[]
        @display={1=>{1=>"\u265A",2=>"\u265B",3=>"\u265D",4=>"\u265E",5=>"\u265C",6=>"\u265F"},
        2=>{1=>"\u2654",2=>"\u2655",3=>"\u2657",4=>"\u2658",5=>"\u2656",6=>"\u2659"}}
    end

    def to_s
        if @set==0 or @type==0
            "."
        else
            "#{@display[@set][@type].encode('utf-8')}"
        end
    end

    def possible_moves(board)
        @moves_list=[]
        case @type
        when 1
            #King's moves
            possibilites=[[0,1],[1,1],[1,0],[1,-1],[0,-1],[-1,-1],[-1,0],[-1,1]]
        when 2
            #Queen's moves
            possibilites=[[[0,1],[0,2],[0,3],[0,4],[0,5],[0,6],[0,7]],
                        [[1,1],[2,2],[3,3],[4,4],[5,5],[6,6],[7,7]],
                        [[1,0],[2,0],[3,0],[4,0],[5,0],[6,0],[7,0]],
                        [[1,-1],[2,-2],[3,-3],[4,-4],[5,-5],[6,-6],[7,-7]],
                        [[0,-1],[0,-2],[0,-3],[0,-4],[0,-5],[0,-6],[0,-7]],
                        [[-1,-1],[-2,-2],[-3,-3],[-4,-4],[-5,-5],[-6,-6],[-7,-7]],
                        [[-1,0],[-2,0],[-3,0],[-4,0],[-5,0],[-6,0],[-7,0]],
                        [[-1,1],[-2,2],[-3,3],[-4,4],[-5,5],[-6,6],[-7,7]]]
        when 3
            #Bishop's moves
            possibilites=[[[1,1],[2,2],[3,3],[4,4],[5,5],[6,6],[7,7]],
                        [[1,-1],[2,-2],[3,-3],[4,-4],[5,-5],[6,-6],[7,-7]],
                        [[-1,-1],[-2,-2],[-3,-3],[-4,-4],[-5,-5],[-6,-6],[-7,-7]],
                        [[-1,1],[-2,2],[-3,3],[-4,4],[-5,5],[-6,6],[-7,7]]]
        when 4
            #Knight's moves
            possibilites=[[1,2],[2,1],[2,-1],[1,-2],[-1,-2],[-2,-1],[-2,1],[-1,2]]
        when 5
            #Rook's moves
            possibilites=[[[0,1],[0,2],[0,3],[0,4],[0,5],[0,6],[0,7]],
                        [[1,0],[2,0],[3,0],[4,0],[5,0],[6,0],[7,0]],
                        [[0,-1],[0,-2],[0,-3],[0,-4],[0,-5],[0,-6],[0,-7]],
                        [[-1,0],[-2,0],[-3,0],[-4,0],[-5,0],[-6,0],[-7,0]]]
        when 6
            #Pawn's moves
            @moves_list.push([@xpos,@ypos+1]) if @ypos<7 and board[@xpos][@ypos+1].type==0 and board[@xpos][@ypos+1].set==0
        else
            puts "Trojan Horse"
        end

        case @type
        when 1,4
            for attempt in possibilites
                x=@xpos+attempt[0]
                y=@ypos+attempt[1]
                if x>=0 and x<=7 and y>=0 and y<=7
                    @moves_list.push([x,y]) if (board[x][y].type==0 and board[x][y].set==0 or board[x][y].set + board[@xpos][@ypos].set==3) 
                end
            end
        when 2,3,5
            for direction in possibilites
                i=0
                while i<7 
                    x=@xpos+direction[i][0]
                    y=@ypos+direction[i][1]
                    if x>=0 and x<=7 and y>=0 and y<=7
                        @moves_list.push([x,y]) if (board[x][y].type==0 and board[x][y].set==0 or board[x][y].set + board[@xpos][@ypos].set==3)
                        i=7 if board[x][y].set + board[@xpos][@ypos].set==3 
                    end
                    i+=1
                end
            end
        end
        pp @moves_list
    end

end

class Chess
    attr_accessor :board
    def initialize
        @board=[]
        @player=0
        init_board
        display_board
        play
    end

    def init_board
        for i in 0..7
            @board[i]=[]
            for j in 0..7
                @board[i].push(Cell.new(i,j)) 
            end
        end

        #Setting white pawns
        for slot in @board[6]
            slot.set=1
            slot.type=6
        end

        #Setting black pawns
        for slot in @board[1]
            slot.set=2
            slot.type=6
        end

        #Setting black types
        for slot in @board[0]
            slot.set=2
        end

        #Setting white types
        for slot in @board[7]
            slot.set=1
        end

        #Setting all other
        for slot in [@board[0],@board[7]]
            slot[0].type=5
            slot[1].type=4
            slot[2].type=3
            slot[3].type=1
            slot[4].type=2
            slot[5].type=3
            slot[6].type=4
            slot[7].type=5
        end

    end

    def display_board
        puts "\n"
        puts "    a  b  c  d  e  f  g  h"
        puts "  --------------------------"
        puts "8 | #{@board[0][0]}  #{@board[0][1]}  #{@board[0][2]}  #{@board[0][3]}  #{@board[0][4]}  #{@board[0][5]}  #{@board[0][6]}  #{@board[0][7]} | 8"
        puts "7 | #{@board[1][0]}  #{@board[1][1]}  #{@board[1][2]}  #{@board[1][3]}  #{@board[1][4]}  #{@board[1][5]}  #{@board[1][6]}  #{@board[1][7]} | 7"
        puts "6 | #{@board[2][0]}  #{@board[2][1]}  #{@board[2][2]}  #{@board[2][3]}  #{@board[2][4]}  #{@board[2][5]}  #{@board[2][6]}  #{@board[2][7]} | 6"
        puts "5 | #{@board[3][0]}  #{@board[3][1]}  #{@board[3][2]}  #{@board[3][3]}  #{@board[3][4]}  #{@board[3][5]}  #{@board[3][6]}  #{@board[3][7]} | 5"
        puts "4 | #{@board[4][0]}  #{@board[4][1]}  #{@board[4][2]}  #{@board[4][3]}  #{@board[4][4]}  #{@board[4][5]}  #{@board[4][6]}  #{@board[4][7]} | 4"
        puts "3 | #{@board[5][0]}  #{@board[5][1]}  #{@board[5][2]}  #{@board[5][3]}  #{@board[5][4]}  #{@board[5][5]}  #{@board[5][6]}  #{@board[5][7]} | 3"
        puts "2 | #{@board[6][0]}  #{@board[6][1]}  #{@board[6][2]}  #{@board[6][3]}  #{@board[6][4]}  #{@board[6][5]}  #{@board[6][6]}  #{@board[6][7]} | 2"
        puts "1 | #{@board[7][0]}  #{@board[7][1]}  #{@board[7][2]}  #{@board[7][3]}  #{@board[7][4]}  #{@board[7][5]}  #{@board[7][6]}  #{@board[7][7]} | 1"
        puts "  --------------------------"
        puts "    a  b  c  d  e  f  g  h"
        puts "\n"
    end

    def play
        @player=1
        while game_not_over?
            puts "Player #{@player} enter your source and destination"
            puts "Source coin : "
            src_flag=true
            while src_flag
                src=gets.chomp
                src_flag=false if check_source(src)==true
            end
            puts "Destination coin : "
            dest_flag=true
            while dest_flag
                dest=gets.chomp
                dest_flag=false if check_source(dest)==true
            end
            display_board
            @player==1?@player=2:@player=1
        end
    end

    def check_source(src)
        if src[0].ord<97 or src[0].ord>104 or src[1].to_i<1 or src[1].to_i>8 or src[2]!=nil
            return false
        else
            return true
        end
    end

    def check_dest(dest)
        if dest[0].ord<97 or dest[0].ord>104 or dest[1].to_i<1 or dest[1].to_i>8 or dest[2]!=nil
            return false
        else
            return true
        end
    end

    def game_not_over?
        return true
    end

end

game=Chess.new
