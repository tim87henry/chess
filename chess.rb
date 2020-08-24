require 'yaml'

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
            newx=[]
            if @set==1
                newx.push(@xpos-1)
                newx.push(@xpos-2) if @xpos==6
            else
                newx.push(@xpos+1)
                newx.push(@xpos+2) if @xpos==1
            end
            for x in newx
                @moves_list.push([x,@ypos]) if x<=7 and x>=0 and board[x][@ypos].type==0 and board[x][@ypos].set==0
            end
            @set==1?x=@xpos-1:x=@xpos+1
            @moves_list.push([x,@ypos+1]) if [0..7].include?x and [0..7].include?@ypos+1 and @set+board[x][@ypos+1].set==3
            @moves_list.push([x,@ypos-1]) if [0..7].include?x and [0..7].include?@ypos-1 and @set+board[x][@ypos-1].set==3
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
                        @moves_list.push([x,y]) if (board[x][y].type==0 and board[x][y].set==0 or (board[x][y].set + board[@xpos][@ypos].set==3))
                        i=7 if [3,4].include?board[x][y].set + board[@xpos][@ypos].set or (board[x][y].set == board[@xpos][@ypos].set)
                    end
                    i+=1
                end
            end
        end
    end

end

class Chess
    attr_accessor :board
    def initialize
        @board=[]
        @player=1
        @mapping={"a"=>0,"b"=>1,"c"=>2,"d"=>3,"e"=>4,"f"=>5,"g"=>6,"h"=>7,0=>8,1=>7,2=>6,3=>5,4=>4,5=>3,6=>2,7=>1,8=>0}
        @reverse_map={0=>"a",1=>"b",2=>"c",3=>"d",4=>"e",5=>"f",6=>"g",7=>"h"}
        start_game
    end

    def start_game
        choice=0
        while choice<1 or choice>2
            puts "Welcome. Do you want to \n\n[1] Load the saved game \n[2] Start a new game\n\n"
            choice=gets.chomp.to_i
            puts "Enter a valid choice\n\n" if choice<1 or choice>2
        end
        if choice==1
            load_game
        else
            init_board
            display_board
            play
        end
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
        while game_not_over?
            puts "Player #{@player} enter your source and destination (Press 's' to save)"
            puts "Select coin : "
            src_flag=true
            while src_flag
                src=gets.chomp
                src_flag=false if check_source(src)==true
                puts "Please enter a valid coin" if src_flag==true
            end
            print "Options are : "
            for opt in find_options(src)
                print opt+" "
            end
            puts "\n"
            puts "Enter destination : "
            dest_flag=true
            while dest_flag
                dest=gets.chomp
                dest_flag=false if check_dest(src,dest)==true
                puts "Please enter a valid move" if dest_flag==true
            end
            make_move(src,dest)
            display_board
            @player==1?@player=2:@player=1
        end
    end

    def check_source(src)
        return false if src.empty?
        save_game if src[0].ord==115
        if src[0].ord<97 or src[0].ord>104 or src[1].to_i<1 or src[1].to_i>8 or src[2]!=nil or @board[@mapping[src[1].to_i]][@mapping[src[0]]].set!=@player
            return false
        else
            @board[@mapping[src[1].to_i]][@mapping[src[0]]].possible_moves(@board)
            if @board[@mapping[src[1].to_i]][@mapping[src[0]]].moves_list.empty?
                return false
            else
                return true
            end
        end
    end

    def check_dest(src,dest)
        return false if dest.empty?
        if dest[0].ord<97 or dest[0].ord>104 or dest[1].to_i<1 or dest[1].to_i>8 or dest[2]!=nil
            return false
        else
            @board[@mapping[src[1].to_i]][@mapping[src[0]]].possible_moves(@board)
            if @board[@mapping[src[1].to_i]][@mapping[src[0]]].moves_list.include?([@mapping[dest[1].to_i],@mapping[dest[0]]])
                return true
            end
        end
        return false
    end

    def make_move(src,dest)
        new_set=@board[@mapping[src[1].to_i]][@mapping[src[0]]].set
        new_type=@board[@mapping[src[1].to_i]][@mapping[src[0]]].type
        @board[@mapping[src[1].to_i]][@mapping[src[0]]].set=0
        @board[@mapping[src[1].to_i]][@mapping[src[0]]].type=0
        @board[@mapping[dest[1].to_i]][@mapping[dest[0]]].set=new_set
        @board[@mapping[dest[1].to_i]][@mapping[dest[0]]].type=new_type
    end

    def find_options(src)
        list=[]
        for option in @board[@mapping[src[1].to_i]][@mapping[src[0]]].moves_list
            list.push("#{@reverse_map[option[1]]}#{@mapping[option[0]]}")
        end
        return list
    end

    def game_not_over?
        puts "CHECK - Please check your King" if is_check?
        if is_check_mate?
            return false
        else
            return true
        end
    end

    def is_check?
        @player==1?test=2:test=1
        for row in @board
            for coin in row
                if coin.set==test
                    coin.possible_moves(@board)
                    for move in coin.moves_list
                        return true if @board[move[0]][move[1]].type==1
                    end
                end
            end
        end
        return false
    end

    def is_check_mate?
        save_state={
            board:@board,
        }
        File.open("./temp_init.yml","w") {|f| f.write(save_state.to_yaml)}
        for row in @board
            for coin in row
                if coin.set==@player
                    coin.possible_moves(@board)
                    for turn in coin.moves_list
                        temp_move([coin.xpos,coin.ypos],turn)
                        save_state={
                            board:@board,
                        }
                        #File.delete("./temp.yml") if File.exist?("./temp.yml")
                        #File.open("./temp.yml","w") {|f| f.write(save_state.to_yaml)}
                        if !king_locked?
                            puts "Not locked due to #{coin.set} and #{coin.type} to #{turn}"
                            load_state=nil
                            load_state=YAML.load(File.read("./temp_init.yml"))
                            @board=load_state[:board]
                            return false
                        end
                    end
                end
                load_state=nil
                load_state=YAML.load(File.read("./temp_init.yml"))
                @board=load_state[:board]
            end
        end
        load_state=YAML.load(File.read("./temp_init.yml"))
        @board=load_state[:board]
        return true
    end

    def temp_move(src,dest)
        temp_set=@board[src[0]][src[1]].set
        temp_type=@board[src[0]][src[1]].type
        @board[src[0]][src[1]].set=0
        @board[src[0]][src[1]].type=0
        @board[dest[0]][dest[1]].set=temp_set
        @board[dest[0]][dest[1]].type=temp_type 
    end

    def king_locked?
        temp_board=@board
        test=@player
        kings_moves=[]
        king_location=[]
        for row in @board
            for coin in row
                if coin.set==test and coin.type==1
                    kings_moves.push([coin.xpos,coin.ypos])
                    king_location=[coin.xpos,coin.ypos]
                    coin.possible_moves(@board)
                    for move in coin.moves_list
                        kings_moves.push(move)
                    end
                end
            end
        end
        puts "King's location is #{king_location} and moves are #{kings_moves}"
        @player==1?test=2:test=1
        #rival_moves=[]
        for move in kings_moves
            temp_move(king_location,move)
            for row in @board
                for coin in row
                    if coin.set==test
                        rival_moves=[]
                        coin.possible_moves(@board)
                        puts "Rival coin is #{coin.type}, at #{[coin.xpos,coin.ypos]}, and moves are #{coin.moves_list}"
                        for turn in coin.moves_list
                            rival_moves.push(turn)
                        end
                    end
                    unless coin.set==test and rival_moves.include?move
                        return false
                    end
                end    
            end
            #unless rival_moves.include?move
            #    return false
            #end
        end
        @board=temp_board
        return true
    end

    def save_game
        puts "Saving game"
        save_state={
            board:@board,
            player:@player,
            mapping:@mapping,
            reverse_map:@reverse_map
        }
        File.open("./saved_game.yml","w") {|f| f.write(save_state.to_yaml)}
        exit
    end

    def load_game
        load_state=YAML.load(File.read("./saved_game.yml"))
        @board=load_state[:board]
        @player=load_state[:player]
        @mapping=load_state[:mapping]
        @reverse_map=load_state[:reverse_map]
        display_board
        play
    end

end

game=Chess.new
