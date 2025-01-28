
clc
clear
% set play again to true so game runs once
playAgain = true;

while playAgain == true
    % initialize all 4 boards
    clc
    clear
    % drawn map of player ships
    playerShipBoard = ones(10,10) .* 2;
    
    % drawn map of where player has shot
    playerColorBoard = ones(10,10) .* 2;
    AIColorBoard = ones(10,10) .* 2;
    
    %map for seperating ship health
    playerShipHealthBoard = zeros(10,10);
    
    % pick randiom preset board for AI
    aiPreset = randi(7);
    
    %make AI ship board depending on preset
    if aiPreset == 1
        AIShipBoard = readmatrix('preset1.txt');
    elseif aiPreset == 2
         AIShipBoard = readmatrix('preset2.txt');
    elseif aiPreset == 3
         AIShipBoard = readmatrix('preset3.txt');
    elseif aiPreset == 4
         AIShipBoard = readmatrix('preset4.txt');
    elseif aiPreset == 5
         AIShipBoard = readmatrix('preset5.txt');
    elseif aiPreset == 6
         AIShipBoard = readmatrix('preset6.txt');
    elseif aiPreset == 7
         AIShipBoard = readmatrix('preset7.txt');
    end
    
    % load in matching AI ship health matrix
    if aiPreset == 1
        AIShipHealthBoard = readmatrix('health1.txt');
    elseif aiPreset == 2
         AIShipHealthBoard = readmatrix('health2.txt');
    elseif aiPreset == 3
         AIShipHealthBoard = readmatrix('health3.txt');
    elseif aiPreset == 4
         AIShipHealthBoard = readmatrix('health4.txt');
    elseif aiPreset == 5
         AIShipHealthBoard = readmatrix('health5.txt');
    elseif aiPreset == 6
         AIShipHealthBoard = readmatrix('health6.txt');
    elseif aiPreset == 7
         AIShipHealthBoard = readmatrix('health7.txt');
    end
    
    %draw scene
    scene = simpleGameEngine('BattleshipExtra2.png', 84,84,1.5,[0,0,0]);
    drawScene(scene,playerShipBoard);
    
    % build phase
    shipPlacing = 1;
 
    
    % matrix of all 5 ships when horizontal, 2 is water mouse will place at 3
    % location
    horShips = [
        3,5,2,2,2;
        3,4,5,2,2;
        3,4,4,5,2;
        3,4,4,4,5];
    % vertical ships in a matrix, 2 is water mouse places at 6
    vertShips = [
        6,6,6,6;
        8,7,7,7;
        2,8,7,7;
        2,2,8,7;
        2,2,2,8];
    
    % tracker for stage of game, 0 is ship placing, 1 is active playing, 2 is
    % winner screen
    % dont use global variables kids, its not good for you.
    gameStage = 0;
    battleFig = getFigure(scene);
    
    
    % 1 is right, 2 down, 3 is left, 4 is up
    rotation = 1;
    
    % check for player key input
    
    
    while shipPlacing <= 4
        title({"Placing Ship of Length " + (shipPlacing + 1), "Press w,a,s,d to Rotate"}, ...
            'Units', 'normalized', 'Position', [.5, 0.53, 1],'Color','red');
        ax = gca;
        ax.TitleFontSizeMultiplier = 2;
            
            rotationChosen = false;
    
            % run until rotation is chosen
            while rotationChosen == false
                  if rotation == 1
                        title({"Placing to the Right, Ship Length is: " + (shipPlacing + 1), "Press w,a,s,d to rotate and p to confirm"}, ...
            'Units', 'normalized', 'Position', [.5, 0.53, 1],'Color','red');
                  elseif rotation == 2
                        title({"Placing Downward, Ship Length is: " + (shipPlacing + 1),"Press w,a,s,d to rotate and p to confirm"}, ...
            'Units', 'normalized', 'Position', [.5, 0.53, 1],'Color','red');
                  elseif rotation == 3
                           title({"Placing to the Left, Ship Length is: " + (shipPlacing + 1),"Press w,a,s,d to rotate and p to confirm"}, ...
            'Units', 'normalized', 'Position', [.5, 0.53, 1],'Color','red');
                  else 
                           title({"Placing Upward, Ship Length is: " + (shipPlacing + 1),"Press w,a,s,d to rotate and p to confirm"}, ...
            'Units', 'normalized', 'Position', [.5, 0.53, 1],'Color','red');
                  end
                   
    
                
                 key = getKeyboardInput(scene);
                 if key == 'p'
                     rotationChosen = true;
                 elseif key == 'w'
                     rotation = 4;
      
                 elseif key == 'a'
                     rotation = 3;
               
                 elseif key == 's'
                     rotation = 2;
       
                 elseif key == 'd'
                     rotation = 1;
                    
                 end
                 
            end
            
           % variable for looping until player chooses valid ship location
        approved = false;
        
        while(approved ~= true)
            % Rotation is locked in so display message saying that
              if rotation == 1
                        title({"Click to Place Left of Ship, Ship Length is: " + (shipPlacing + 1)}, ...
            'Units', 'normalized', 'Position', [.5, 0.53, 1],'Color','red');
                  elseif rotation == 2
                              title({"Click to Place Top of Ship, Ship Length is: " + (shipPlacing + 1)}, ...
            'Units', 'normalized', 'Position', [.5, 0.53, 1],'Color','red');
                  elseif rotation == 3
                         title({"Click to Place Right of Ship, Ship Length is: " + (shipPlacing + 1)}, ...
            'Units', 'normalized', 'Position', [.5, 0.53, 1],'Color','red');
                  else 
                         title({"Click to Place Bottom of Ship, Ship Length is: " + (shipPlacing + 1)}, ...
            'Units', 'normalized', 'Position', [.5, 0.53, 1],'Color','red');
              end
    
            % get mouse input
            [row, column] = getMouseInput(scene);
          
    
            % authenticate spot horizontal (place at left)
            if rotation == 1
               % check if empty spaces to the right as needed
               gapNeeded = 10 - shipPlacing;
               iterator = 10 - gapNeeded;
               enoughGap = true;
    
               for i = 0:iterator
                   % if too close to edge (very inneficient but thats for
                   % software 1 not this class)
                   if (shipPlacing + column) > 10
                        enoughGap = false;
                   elseif (playerShipBoard(row,column + i) ~= 2)
                        % if iterating space is not water then we unapp
                        enoughGap = false;
                   end
               end
            elseif rotation == 2
                % authenticate spot verticle (place at top)
                gapNeeded = 10 - shipPlacing;
                iterator = 10 - gapNeeded;
                enoughGap = true;
    
                for i = 0:iterator
                    % check for enough gap to edge
                    if (shipPlacing + row) > 10
                        enoughGap = false;
                        
                    elseif playerShipBoard(row + i, column) ~= 2
                        % space down is not water
                        enoughGap = false;
    
                    end
                end
            elseif rotation == 3
                % authenticate spot horizontal (place at right
                enoughGap = true;
                
                for i = 0:shipPlacing
                    %check if enough space to edge of map
                    if shipPlacing >= column
                        enoughGap = false;
                    elseif (playerShipBoard(row,column - i) ~= 2)
                        %check if any ship in the way
                        enoughGap = false;
                    end
    
                end
            else
                %authenticate spot verticle (place at bottom)
                enoughGap = true;
    
                for i =0:shipPlacing
                    % check for edge of map
                    if shipPlacing >= row
                        enoughGap = false;
                    elseif (playerShipBoard(row-i,column) ~= 2)
                        enoughGap = false;
                    end
                end
            end
         
             % check if enough gap to approve
               if enoughGap == true
                   approved = true;
               end
        end
        
        % finished authenticating spot so now we place
        if rotation == 1
            for i = 1:shipPlacing+1
                % replace next 5 with ships
                playerShipBoard(row,(column + i - 1)) = horShips(shipPlacing,i);
    
                %change ship health board so we can tell what ship is where
                playerShipHealthBoard(row,(column + i - 1)) = shipPlacing;
            end
        elseif rotation == 2
            for i = 1:shipPlacing + 1
               %  replace next 5? down with ships
               playerShipBoard((row + i -1),column) = vertShips(i,shipPlacing);
    
               %change ship health board so we can tell what ship is where
                
               playerShipHealthBoard((row + i -1),column) = shipPlacing;
            end
        elseif rotation == 3
            for i = 1:shipPlacing + 1
               %  replace next ship length left with ships (step backwards
               %  through matrixes)
               playerShipBoard(row,column + 1 - i) = horShips(shipPlacing,shipPlacing + 2 - i);
    
               %change ship health board so we can tell what ship is where
               playerShipHealthBoard(row,column + 1 - i) = shipPlacing;
    
            end
        elseif rotation == 4
            for i = 1:shipPlacing + 1
                playerShipBoard(row+1-i, column) = vertShips(shipPlacing + 2 - i,shipPlacing);
    
                %change ship health board so we can tell what ship is where
                playerShipHealthBoard(row+1-i, column) = shipPlacing;
    
            end
        end
    
        
        % redraw scene
        drawScene(scene,playerShipBoard);
    
    
        % increment ship pressed
        shipPlacing = shipPlacing + 1;
    
    end
    
     title("All Ships Places",'Units', 'normalized', 'Position', [.5, 0.53, 1],'Color','red');
    pause(3); %3
    
    
    % game phase


    winner = "";
    playerShip1HP = 2;
    playerShip2HP = 3;
    playerShip3HP = 4;
    playerShip4HP = 5;
    player1ShipsAlive = 4;
    
    AIShip1HP = 2;
    AIShip2HP = 3;
    AIShip3HP = 4;
    AIShip4HP = 5;
    AIShipsAlive = 4;
    
    % initialise turn counter
    turn = 1;
    %initialise variable to run loop until someone wins
    gamePlaying = true;
    while gamePlaying == true
        
        %only start each turn if someone hasnt won
        if gamePlaying == true
            % player turn
             title("Player Turn " + turn,'Units', 'normalized', 'Position', [.5, 0.53, 1],'Color','red');
             pause(0.5); %0.5
            % draw shot board
            drawScene(scene,playerColorBoard)
            pause(1) %1
        
             title("Click to take your shot!",'Units', 'normalized', 'Position', [.5, 0.53, 1],'Color','red');
        
            [row,column] = getMouseInput(scene);
             while playerColorBoard(row,column) ~= 2
                    %loop until valid input
                    [row, column] = getMouseInput(scene);
             end
        
            if AIShipBoard(row,column) ~= 2
                playerColorBoard(row,column) = 18;
                 %redraw color board
                drawScene(scene,playerColorBoard);

                % change health of ship hit
                if AIShipHealthBoard(row,column) == 1
                    AIShip1HP = AIShip1HP - 1;
                    if AIShip1HP == 0
                        [winner,player1ShipsAlive,AIShipsAlive] = shipDestroyed(player1ShipsAlive,AIShipsAlive,'PLAYER');
                        % check for winner
                        if strcmp(winner,'NONE') == false
                             displayWinner(winner)
                             gamePlaying = false;
                        end
                    end
                elseif AIShipHealthBoard(row,column) == 2
                    AIShip2HP = AIShip2HP - 1;
                    if AIShip2HP == 0
                         [winner,player1ShipsAlive,AIShipsAlive] = shipDestroyed(player1ShipsAlive,AIShipsAlive,'PLAYER');
                        % check for winner
                        if strcmp(winner,'NONE') == false
                             displayWinner(winner)
                             gamePlaying = false;
                        end
                    end
                elseif AIShipHealthBoard(row,column) == 3
                    AIShip3HP = AIShip3HP - 1;
                    if AIShip3HP == 0
                        [winner,player1ShipsAlive,AIShipsAlive] = shipDestroyed(player1ShipsAlive,AIShipsAlive,'PLAYER');
                        % check for winner
                        if strcmp(winner,'NONE') == false
                             displayWinner(winner)
                             gamePlaying = false;
        
                        end
                    end
                elseif AIShipHealthBoard(row,column) == 4
                    AIShip4HP = AIShip4HP - 1;
                    if AIShip4HP == 0
                       [winner,player1ShipsAlive,AIShipsAlive] = shipDestroyed(player1ShipsAlive,AIShipsAlive,'PLAYER');
                        % check for winner
                        if strcmp(winner,'NONE') == false
                             displayWinner(winner)
                        gamePlaying = false;
                        end
                    end
                end
            else
                playerColorBoard(row,column) = 17;
            end
            
            %Redraw scene 
            drawScene(scene,playerColorBoard)
            pause(1) %1
        end

        %only do AI turn if player didnt win before
        if gamePlaying == true
        % AI turn

         % display player ship board
        drawScene(scene,playerShipBoard);

         title("AI Turn " + turn,'Units', 'normalized', 'Position', [.5, 0.53, 1],'Color','red');
         pause(0.5); %0.5
         title("AI is Shooting!",'Units', 'normalized', 'Position', [.5, 0.53, 1],'Color','red');
         pause(0.2);
    
       
        
        % pick random spot to shoot
        AIrow = randi(10);
        AIcolumn = randi(10);
        
        while AIColorBoard(AIrow,AIcolumn) ~= 2
            % keep picking random spot until we have not shot there yet
            AIrow = randi(10);
            AIcolumn = randi(10);
        end
        
        %once spot is picked we "shoot" there
    
        AIColorBoard(AIrow,AIcolumn) = 0;
        
        if playerShipHealthBoard(AIrow,AIcolumn) == 1
            % redraw ship 1
            if playerShipBoard(AIrow,AIcolumn) == 3
                playerShipBoard(AIrow,AIcolumn) = 13;
            elseif  playerShipBoard(AIrow,AIcolumn) == 4
                playerShipBoard(AIrow,AIcolumn) = 15;
            elseif playerShipBoard(AIrow,AIcolumn) == 5
                playerShipBoard(AIrow,AIcolumn) = 14;
            elseif playerShipBoard(AIrow,AIcolumn) == 6
                playerShipBoard(AIrow,AIcolumn) = 16;
            elseif playerShipBoard(AIrow,AIcolumn) == 7
                playerShipBoard(AIrow,AIcolumn) = 11;
            elseif  playerShipBoard(AIrow,AIcolumn) == 8
                playerShipBoard(AIrow,AIcolumn) = 12;
            end
             
            %hit ship 1
            playerShip1HP = playerShip1HP - 1;
            if playerShip1HP == 0
                    [winner,player1ShipsAlive,AIShipsAlive] = shipDestroyed(player1ShipsAlive,AIShipsAlive,'AI');
                    % check for winner
                    if strcmp(winner,'NONE') == false
                         displayWinner(winner)
                        gamePlaying = false;
                    end
            end
        elseif  playerShipHealthBoard(AIrow,AIcolumn)  == 2
            %redraw
            if playerShipBoard(AIrow,AIcolumn) == 3
                playerShipBoard(AIrow,AIcolumn) = 13;
            elseif  playerShipBoard(AIrow,AIcolumn) == 4
                playerShipBoard(AIrow,AIcolumn) = 15;
            elseif playerShipBoard(AIrow,AIcolumn) == 5
                playerShipBoard(AIrow,AIcolumn) = 14;
            elseif playerShipBoard(AIrow,AIcolumn) == 6
                playerShipBoard(AIrow,AIcolumn) = 16;
            elseif playerShipBoard(AIrow,AIcolumn) == 7
                playerShipBoard(AIrow,AIcolumn) = 11;
            elseif  playerShipBoard(AIrow,AIcolumn) == 8
                playerShipBoard(AIrow,AIcolumn) = 12;
            end
    
             %hit ship 2
            playerShip2HP = playerShip1HP - 1;
            if playerShip2HP == 0
                    [winner,player1ShipsAlive,AIShipsAlive] = shipDestroyed(player1ShipsAlive,AIShipsAlive,'AI');
                    % check for winner
                    if strcmp(winner,'NONE') == false
                         displayWinner(winner)
                        gamePlaying = false;
                    end
            end
        elseif playerShipHealthBoard(AIrow,AIcolumn)  == 3
                %redraw
            if playerShipBoard(AIrow,AIcolumn) == 3
                playerShipBoard(AIrow,AIcolumn) = 13;
            elseif  playerShipBoard(AIrow,AIcolumn) == 4
                playerShipBoard(AIrow,AIcolumn) = 15;
            elseif playerShipBoard(AIrow,AIcolumn) == 5
                playerShipBoard(AIrow,AIcolumn) = 14;
            elseif playerShipBoard(AIrow,AIcolumn) == 6
                playerShipBoard(AIrow,AIcolumn) = 16;
            elseif playerShipBoard(AIrow,AIcolumn) == 7
                playerShipBoard(AIrow,AIcolumn) = 11;
            elseif  playerShipBoard(AIrow,AIcolumn) == 8
                playerShipBoard(AIrow,AIcolumn) = 12;
            end
                %hit ship 3
            playerShip3HP = playerShip1HP - 1;
            if playerShip3HP == 0
                    [winner,player1ShipsAlive,AIShipsAlive] = shipDestroyed(player1ShipsAlive,AIShipsAlive,'AI');
                    % check for winner
                    if strcmp(winner,'NONE') == false
                         displayWinner(winner)
                        gamePlaying = false;
                    end
            end
        elseif playerShipHealthBoard(AIrow,AIcolumn)  == 4
            %redraw
            if playerShipBoard(AIrow,AIcolumn) == 3
                playerShipBoard(AIrow,AIcolumn) = 13;
            elseif  playerShipBoard(AIrow,AIcolumn) == 4
                playerShipBoard(AIrow,AIcolumn) = 15;
            elseif playerShipBoard(AIrow,AIcolumn) == 5
                playerShipBoard(AIrow,AIcolumn) = 14;
            elseif playerShipBoard(AIrow,AIcolumn) == 6
                playerShipBoard(AIrow,AIcolumn) = 16;
            elseif playerShipBoard(AIrow,AIcolumn) == 7
                playerShipBoard(AIrow,AIcolumn) = 11;
            elseif  playerShipBoard(AIrow,AIcolumn) == 8
                playerShipBoard(AIrow,AIcolumn) = 12;
            end
    
                %hit ship 4
            playerShip4HP = playerShip4HP - 1;
            if playerShip4HP == 0
                    [winner,player1ShipsAlive,AIShipsAlive] = shipDestroyed(player1ShipsAlive,AIShipsAlive,'AI');
                    % check for winner
                    if strcmp(winner,'NONE') == false
                        displayWinner(winner)
                        gamePlaying = false;
                         
                    end
            end
        else
            %miss
            playerShipBoard(AIrow,AIcolumn) = 17;
        end

        %redraw player ship board
         drawScene(scene,playerShipBoard);
         pause(2); %2
    
        
        end
        turn = turn + 1;
    end

    %ask user to play again or not
    title("Would you like to play again? (y/n): ",'Units', 'normalized', 'Position', [.5, 0.53, 1],'Color','red');
    key = getKeyboardInput(scene);
    if key == 'y'
        playAgain = true;
        close(battleFig);
    else
        playAgain = false;
        close(battleFig);
    end
end

function [winner,playerShipsAlive,AIShipsAlive] = shipDestroyed(playerShipsAlive, AIShipsAlive, turn)
    title("SHIP DESTROYED!",'Units', 'normalized', 'Position', [.5, 0.53, 1],'Color','red');
    pause(1);
    if strcmp('AI',turn) == true
        playerShipsAlive = playerShipsAlive - 1;
        if playerShipsAlive == 0
            winner = 'AI';
        else
            winner = 'NONE';
        end
    else
        AIShipsAlive = AIShipsAlive - 1;
        if AIShipsAlive == 0
            winner = 'PLAYER';
        else
            winner = 'NONE';
        end
    end
end

%void end game function
function displayWinner(winner)
     title("THE WINNER IS: " + winner,'Units', 'normalized', 'Position', [.5, 0.53, 1],'Color','red');
     pause(3);
end

