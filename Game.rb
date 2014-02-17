#caterpillar
#programmer:Shouhan Cheng 'Ethan'
#Version:1.0

require 'gosu'#reuqire lib
#Game window
class GameWindow < Gosu::Window
  def initialize
   #initializer, declare and initial all necessary variables
   @speed = 100 #update interval
   @width = 640 #window width
   @height = 480 #window height
   @unit = 20 #unit size
   @num_win = @width * @height / @unit ** 2 * 10 #max score can eared in this game
   super @width,@height,false,@speed #window constructor
   self.caption = "Caterpillar" #window title
   @caterpillar = Caterpillar.new(self) #create a new caterpillar
   @cabbage = Cabbage.new(self) #new cabbage
   @font = Gosu::Font.new(self, Gosu::default_font_name, 20) #a font obj
   @x = 0 # x coordinate
   @y = 1 # y coordinate
   @score = 0 #score
   @head = 0 # head position
   @welcome = true #welcome boolean tests if just opened the game
   @paused = false #paused boolean tests if the game is paused
   @lost = false #lost boolean tests if the player lost
   @win = false #win boolean tests if the player won
   #some txt for display
   @p_txt = "Game Paused"
   @r_txt = "To resume Game, Press ENTER"
   @l_txt = "You Lost and your score is:"
   @t_txt = "Press R to retry"
   @q_txt = "Press ESC to quit"
   @w_txt = "Welcome to caterpillar game"
   @i1_txt = "Press arrow keys to control your caterpillar"
   @i2_txt = "Each cabbage worth 10 points"
   @i3_txt = "Eating yourself or hitting the wall will casue you lose"
   @i4_txt = "Press ESC anytime to quit"
   @i5_txt = "Press b to begin"
   @win_txt = "Oh wow, unbelievale, you won!"
   @win2_txt = "Press ESC to quit, Press R to play again"
  end

  #draw function
  def draw
    #if game just been opened, display welcome message
    if @welcome then
      @font.draw(@w_txt, 180, 160, 0, factor_x = 1, factor_y = 1, 
                 color = 0xffffffff, mode = :default)
      @font.draw(@i1_txt, 130, 190, 0, factor_x = 1, factor_y = 1, 
                 color = 0xffffffff, mode = :default)
      @font.draw(@i2_txt, 180, 220, 0, factor_x = 1, factor_y = 1, 
                 color = 0xffffffff, mode = :default)   
      @font.draw(@i3_txt, 100, 250, 0, factor_x = 1, factor_y = 1, 
                 color = 0xffffffff, mode = :default)
      @font.draw(@i4_txt, 200, 280, 0, factor_x = 1, factor_y = 1, 
                 color = 0xffffffff, mode = :default)
      @font.draw(@i5_txt, 240, 310, 0, factor_x = 1, factor_y = 1, 
                 color = 0xffffffff, mode = :default)
    end
    #if game paused, display paused message
    if @paused then
      @font.draw(@p_txt, 250, 200, 0, factor_x = 1, factor_y = 1, 
                 color = 0xffffffff, mode = :default)
      @font.draw(@r_txt, 180, 280, 0, factor_x = 1, factor_y = 1, 
                 color = 0xffffffff, mode = :default)
    end

    #if game lost, display message
    if @lost then
      @font.draw(@l_txt, 180, 200, 0, factor_x = 1, factor_y = 1, 
                  color = 0xffffffff, mode = :default)
      @font.draw(@score, 285, 220, 0, factor_x = 1, factor_y = 1, 
                  color = 0xffffffff, mode = :default)
      @font.draw(@t_txt, 220, 240, 0, factor_x = 1, factor_y = 1, 
                  color = 0xffffffff, mode = :default)   
      @font.draw(@q_txt, 220, 260, 0, factor_x = 1, factor_y = 1, 
                  color = 0xffffffff, mode = :default)
    end

    #if won, display message
    if @win then
      @font.draw(@win_txt, 180, 200, 0, factor_x = 1, factor_y = 1, 
                  color = 0xffffffff, mode = :default)
      @font.draw(@win2_txt, 140, 230, 0, factor_x = 1, factor_y = 1, 
                  color = 0xffffffff, mode = :default)
    end

    #in game
    if !@paused and !@lost and !@welcome and !@win then
      @caterpillar.draw
      @cabbage.draw
      @font.draw("SCORE: #{@score}", 550, 0, 0, factor_x = 0.7, factor_y = 0.7, 
                 color = 0xffffffff, mode = :default)
    end  
  end
  
  #update
  def update
    #key B for begin
    if button_down? Gosu::KbB then
      @welcome = false
    end
    #key Space for pause
    if button_down? Gosu::KbSpace then
        @paused = true
    end
    #Return Key for continue
    if button_down? Gosu::KbReturn then
        @paused = false
    end
    #R Key for reset game 
    if button_down? Gosu::KbR and (@win or @lost)then
        reset
    end
    #ESC to quit game
    if button_down? Gosu::KbEscape then
        self.close
    end
    #in game
    if !@paused and !@lost and !@welcome and !@win then
  	  #move left
      if button_down? Gosu::KbLeft then
  	   	 @caterpillar.left
      end
      #move right
  	  if button_down? Gosu::KbRight then
  		  @caterpillar.right
  	  end
      #move up
  	  if button_down? Gosu::KbUp then
  	   	@caterpillar.up
  	  end
      #move down
  	  if button_down? Gosu::KbDown then
  		  @caterpillar.down
  	  end	
      #find current locations of caterpillar and cabbage
      $cab_loc = @cabbage.cur_loc
      $cat_loc = @caterpillar.cur_loc
      #test if the cabbage is eaten by caterpillar
      if $cat_loc[0] == $cab_loc then
        @cabbage.set_Eaten(true)
        @caterpillar.grow(self) 
        @score += 10 
      end
      #if the cabbage location overlapping with caterpillar's. regenerate
      if $cat_loc.include?($cab_loc) then
        @cabbage.locGerenator
      end
      #if the caterpillar eats itself, game over
      if $cat_loc.uniq.length < $cat_loc.length then
        @lost = true
      end
      #if the caterpillar hit the walls, game over
      if $cat_loc[@head][@x] < 0 or $cat_loc[@head][@x] > 640 or
        $cat_loc[@head][@y] < 0 or $cat_loc[@head][@y] > 480 then
        @lost = true
      end
      #if score reach max, win
      if @score  == @num_win then
        @win = true
      end
      #if not lost, move caterpillar
      if @lost != true then
        @caterpillar.move
      end
    end
  end
  #reset 
  def reset
    #reset necessary varibales
    @caterpillar = Caterpillar.new(self)
    @cabbage = Cabbage.new(self)
    @score = 0
    @paused = false
    @lost = false
    @win = false
  end
end


 class Caterpillar	
  #initializer
 	def initialize(window)
 		@dir_north = 0 #direction north(up)
 	  @dir_south = 1 #direction south(down)
    @dir_west = 2 #direction west(left)
    @dir_east = 3 #direction east(right)
    @direction = @dir_north #set default direction to north
 		@unit = 20 #unit size
    @origin_x = 320 #default x coordinate
    @origin_y = 240 #default y coordinate
    @origin_z = 0   #default z coordinate
 		@x = 0 #x coordinate
 		@y = 1 #y coordinate
    @z = 2 #z coordinate
    @head = 0 #head position
    @image_arr = Array.new(1) #array holds image
 	  @image_arr[0] = Gosu::Image.new(window,"square.png",true) #declare first piece of body   
    @loc_arr = [[@origin_x,@origin_y,@origin_z]] #add default origin to the loc array
 	end

  #draw
 	def draw
 		#draw each piece of the body
    for i in 0..@loc_arr.length - 1
 			@image_arr[i].draw(@loc_arr[i][@x],@loc_arr[i][@y],@loc_arr[i][@z])
 		end 
 	end

  #move
 	def move
    #move the caterpillar
    $temp
 		if @direction == @dir_north then 
 			$temp = [@loc_arr[@head][@x],@loc_arr[@head][@y] - @unit,@loc_arr[@head][@z]]
 		end

 		if @direction == @dir_south then
 			$temp = [@loc_arr[@head][@x],@loc_arr[@head][@y] + @unit,@loc_arr[@head][@z]]
 		end

 		if @direction == @dir_east then
 			$temp = [@loc_arr[@head][@x] + @unit,@loc_arr[@head][@y],@loc_arr[@head][@z]]
 		end

 		if @direction == @dir_west then
 			$temp = [@loc_arr[@head][@x] - @unit,@loc_arr[@head][@y],@loc_arr[@head][@z]]
 		end
    @loc_arr.unshift($temp)
    @loc_arr.pop
 	end

  def grow(window)
    #grow
    $new_body = Gosu::Image.new(window,"square.png",false)
    @image_arr.unshift($new_body)
    $temp
    if @direction == @dir_north then 
      $temp = [@loc_arr[@head][@x],@loc_arr[@head][@y] - @unit,@loc_arr[@head][@z]]
    end

    if @direction == @dir_south then
      $temp = [@loc_arr[@head][@x],@loc_arr[@head][@y] + @unit,@loc_arr[@head][@z]]
    end

    if @direction == @dir_east then
      $temp = [@loc_arr[@head][@x] + @unit,@loc_arr[@head][@y],@loc_arr[@head][@z]]
    end

    if @direction == @dir_west then
      $temp = [@loc_arr[@head][@x] - @unit,@loc_arr[@head][@y],@loc_arr[@head][@z]]
    end
    @loc_arr.unshift($temp)
  end

  #movement to all directions
 	def left
    if @direction != @dir_east then
 		 @direction = @dir_west
 	  end
  end

 	def right
    if @direction != @dir_west then
 	  	@direction = @dir_east
    end
 	end

 	def up
    if @direction != @dir_south then
 		 @direction = @dir_north
    end 
 	end

 	def down
    if @direction != @dir_north then
 		 @direction = @dir_south
 	  end
  end

  #access to the loacation array
  def cur_loc
    @loc_arr
  end

 end


 class Cabbage
  #initializer
 	def initialize(window)
 		@image_Cab = Gosu::Image.new(window,"cabbage.png",false)
    @beep_Cab = Gosu::Song.new(window,"beep.wav")
    @x = 0
    @y = 1
    @z = 2
    @unit = 20
    @width = 640
    @height = 480
    @loc_arr = Array.new(3)
    @eaten = false 
    locGerenator
 	end
  #draw
  def draw 
    #if not eaten, draw the cabbage at same location 
    if !@eaten then
      @image_Cab.draw(@loc_arr[@x],@loc_arr[@y],@loc_arr[@z])
    end
    #if eaten, generate new location and draw
    if @eaten then
      locGerenator
      @image_Cab.draw(@loc_arr[@x],@loc_arr[@y],@loc_arr[@z])
      @eaten = false
    end
  end
  #location generator
  def locGerenator
    @loc_arr[@x] = Random.rand(0...@width)
    @loc_arr[@y] = Random.rand(0...@height)
    @loc_arr[@z] = 0
    #line up cabbage on x and y coordinate if not lined up
    while @loc_arr[@x] % @unit != 0 do 
      @loc_arr[@x] = Random.rand(0...@width)
    end

    while @loc_arr[@y] % @unit != 0 do 
      @loc_arr[@y] = Random.rand(0...@height)
    end
  end
  #if eaten, play sound and change eaten value
  def set_Eaten(value)
    @beep_Cab.play(true)
    @eaten = value
    @beep_Cab.play(false)
  end
  #an access to the location 
  def cur_loc
    @loc_arr
  end
 end
#call the window
window = GameWindow.new
window.show