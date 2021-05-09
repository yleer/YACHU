# YACHU


1. 프로젝트의 목적 및 용도



<img src="https://user-images.githubusercontent.com/48948578/117566071-731ec200-b0ef-11eb-83a5-39e8826a5bf1.gif" width="300" height="600" />  |  <img width="300" height="600" alt="스크린샷 2021-05-09 오후 5 46 10" src="https://user-images.githubusercontent.com/48948578/117565873-94cb7980-b0ee-11eb-8631-5d14c2c20260.png">



  이 프로젝트는 무엇을 위한 것인가
  
    친구와 함께 어디서든 야추를 할 수 있게 야추를 아이폰 어플로 구현하였다.
  
  이 프로젝트는 어떻게 작동하는가
    이 게임은 2인이 하는 게임으로 턴을 돌아가면서 플레이하다. 
    한턴에 총 3번 주사위를 굴릴 기회가 있으며 원하는 주사위를 keep할수 있다. 
    이 방식을 통해 자신이 원하는 족보의 주사위를 만들어 상대보다 높은 점수를 얻으면 이기는 게임이다.
    
    이 게임의 족보는 총 12가지가 있다.
    
    Ones - 주사위 5개중 1들의 합.
    Two - 주사위 5개중 2들의 합.
    Threes - 주사위 5개중 3들의 합.
    Fours - 주사위 5개중 4들의 합.
    Fives - 주사위 5개중 5들의 합.
    Sixes - 주사위 5개중 6들의 합.
    
    Choice - 어떤 숫자인지에 상관없이 주사위 5개의 총 합. 
    Four Of a Kind - 같은 주사위가 4개일때 주사위 5개의 총합. 같은 주사위 4개가 없으면 0
    Small Straight - 연달은 수 3개 나올시 5개 주사위 총합
    Large Straight - 연달은 수 4개 나올시 5개 주사위 총합.
    Full House - 같은 주사위가 3개 2개로 
    Yachu - 5개 주사위 모두 같을 시 35점 지급.



2. 프로젝트를 시작하는 방법

 https://github.com/yleer/YACHU.git 주소를 복사해 Xcode에서 Clone existing project에 기입한다.
 
 
3. 만든 방법. 

  점수판 만든 방법
  
  보드 만든 방법
    - 두 겹의 UIView를 이용하여 색만 다르게 하여 보드와 비슷한 모양을 만들었다.
  
  주사위 만든 방법
    - 주사위들은 ImageView 객체들로 선택된 주사위를 이동시키는 것은 UIViewPropertyAnimator로 선택된 주사위의 x, y 좌표를 변화시키는 것으로 이동하는 효과를 주었다.
    - 주사위를 돌릴 때는 UIView.animate를 이용하여 원래의 크기보다 5배 커지고, 한바퀴 돌면서 오른쪽으로 50만큼 가는 효과를 통해 주사위가 돌아가는 효과를 구현하였다.

                    dice.transform = CGAffineTransform(scaleX: 5, y: 5)
                    dice.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                    dice.transform = CGAffineTransform(translationX: 50, y: 0)
        
        주사위 돌아가는 효과는 https://github.com/revolalex/IOS-SWIFT-Animation-RIsk-Dice 참고함.
  





