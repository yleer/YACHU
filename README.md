# YACHU

While spending time with friends or family, there are some times when there is nothing to do. So boring that wish there is something to do, but all they have is a smart phone. To make some fun, using smart phone I planned to make Yacht game in smart phone. I wish some people will enjoy this game.

    Yacht gmae rule - https://namu.wiki/w/%EC%9A%94%ED%8A%B8(%EA%B2%8C%EC%9E%84)?from=Yacht%20Dice 

<img src="https://user-images.githubusercontent.com/48948578/117566071-731ec200-b0ef-11eb-83a5-39e8826a5bf1.gif" width="300" height="600" />  |  <img width="300" height="600" alt="스크린샷 2021-05-09 오후 5 46 10" src="https://user-images.githubusercontent.com/48948578/117565873-94cb7980-b0ee-11eb-8631-5d14c2c20260.png">


# Contents
+ [Why?](#why)
+ [Installation](#Installation)
+ [Usage](#Usage)
+ [How FoodChooser is made](#How-FoodChooser-is-made)
  
  
***
### Why?
  
  
***
### Installation
Install the project.
> + Clone the project.    

    https://github.com/yleer/YACHU.git  
> + Or download the zip file.


    
  
***
### Usage
+ Basically this project works same as the real two player Yatc Game. As the picture above there is a roll button, which rolls the dice. When the player rolls the dice, player has a choice to either roll again or select dice in the board to keep. If the player wants to keep the dice, player can simply touch the dice he wants to keep. If the player want to disselect the dice, player can just select the dice in the deck to disselct. The player continues this process three times or until gets the dice set he wants. After the player is satisfied with the dice set or three times has passed, the player can choose the score in the score board to confirm his points and ends the turn.

+ In the Main View Controller(First image above) player can see only the current player's score board. However, while in one player's turn the player might want to see other player's score. In this case, player can see other player's score by tapping see score button on the top of the score board. By tapping this button, it leads to Score Board View Controller(Second image above), which shows both player's score boards.


   
 
***
### How YACHU is made

  점수판 만든 방법
    - UIView들을 stack에 담아 구현하였다. 점수판의 구분 선 같은 경우 UIView의 width혹은 height를 1로 설정하여 stack 안에 둠으로 구현하였다.
  보드 만든 방법
    - 두 겹의 UIView를 이용하여 색만 다르게 하여 보드와 비슷한 모양을 만들었다.
  
  주사위 만든 방법
    - 주사위들은 ImageView 객체들로 선택된 주사위를 이동시키는 것은 UIViewPropertyAnimator로 선택된 주사위의 x, y 좌표를 변화시키는 것으로 이동하는 효과를 주었다.
    - 주사위를 돌릴 때는 UIView.animate를 이용하여 원래의 크기보다 5배 커지고, 한바퀴 돌면서 오른쪽으로 50만큼 가는 효과를 통해 주사위가 돌아가는 효과를 구현하였다.

                    dice.transform = CGAffineTransform(scaleX: 5, y: 5)
                    dice.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                    dice.transform = CGAffineTransform(translationX: 50, y: 0)
        
        주사위 돌아가는 효과는 https://github.com/revolalex/IOS-SWIFT-Animation-RIsk-Dice 참고함.
  





