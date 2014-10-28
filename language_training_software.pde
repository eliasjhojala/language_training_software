
//This sketch will ask a question, wait for an answer, and then compare the two. If the answer is right, it will not ask that question again. It will only ask it again if it went wrong. This happens until the user has answered right to all questions.


void setup() {
  size(500, 500);
  //Load the table of words
  //--todo
}
//Q&A
String[] q = {"One", "Two", "Three"};
String[] a = {"1",   "2",   "3"    };

//Whether to allow an answer to act as a question (and the question to act as the answer)
boolean allowAnswerAsQuestion = true;
//Display the right answer if the user answers wrong?
boolean displayAnswerOnWrong = true;

boolean caseSensitive = false;

//


boolean[] asked = new boolean[q.length];
boolean[] answRight = new boolean[q.length];

String nowWriting = "";
boolean selected = false;
int selection;
boolean selectionIsInverse = false;
boolean quizOver = false;

int wrongDisplayStart;
boolean wrongDisplay;
String rightAnswer;


void draw() {  
  if (!selected) {
    //There is no question being answered ---> select a new one.
    //Check if any unasked questions are left
    boolean questionsLeft = false;
    for (int i = 0; i < asked.length; i++) {
      if (!asked[i] && !answRight[i]) {
        questionsLeft = true;
        break;
      }
    }
    if (questionsLeft) {
      //Select a new question
      selectNewQuestion();
    } else {
      //No questions left. Start a new round
      if (startNewRound()) {
        //all questions right, quiz over!
        //todo: end quiz
        answRight = new boolean[q.length];
        asked = new boolean[q.length];
        background(0);
        fill(255, 0, 0);
        textSize(30);
        text("Quiz over! Press to restart. ", 20, 50);
        quizOver = true;
        noLoop();
        
      }
    }
  } else {
    //A question is selected. Draw it, and check for completion
    String tempQ, tempA;
    if (!selectionIsInverse) { tempQ = q[selection]; tempA = a[selection]; }
                        else { tempA = q[selection]; tempQ = a[selection]; }
    background(0);
    fill(255);
    stroke(255);
    textSize(32);
    text("Question: ", 20, 200);
    textSize(22);
    text(tempQ, 30, 250);
    text("A: " + nowWriting, 20, 480);
    line(40, 490, 480, 490);
    boolean doDisplay = wrongDisplayStart + 2000 > millis();
    if (wrongDisplay) {
      //Last answer right
      if (doDisplay) {
        fill(0, 255, 0);
        text("Right!", 20, 42);
      }
    } else if(doDisplay) {
      fill(255, 0, 0);
      text("Wrong! It was: " + rightAnswer, 20, 42);
    }
      
    
    if (enterPressed) {
      //Answer submitted
      enterPressed = false;
      
      if (caseSensitive) answRight[selection] = nowWriting.toLowerCase().equals(tempA.toLowerCase());
                    else answRight[selection] = nowWriting.equals(tempA);
      
      wrongDisplay = answRight[selection];
      wrongDisplayStart = millis();
      rightAnswer = tempA;
      
      selected = false;
      nowWriting = "";
    }
  }
}


void mousePressed() {
  if (quizOver) {loop(); quizOver = false;}
}

boolean enterPressed;
void keyPressed() {
  if (!enterPressed) enterPressed = keyCode == ENTER || keyCode == RETURN;
  if (!enterPressed) {
    if (keyCode == BACKSPACE) {
      if (nowWriting.length() != 0) nowWriting = nowWriting.substring(0, nowWriting.length() - 1);
    } else {
      try {
        nowWriting = nowWriting + key;
      } catch(Exception ex) { return; }
    }
  }
}

//Warning! Only call this void after checking that there are unaswered questions left.
void selectNewQuestion() {
  selection = -1;
    while (selection == -1) {
      int index = constrain(round(random(-0.5, asked.length - 0.5)), 0, asked.length - 1);
      if(!asked[index] && !answRight[index]) {
        selection = index;
        selectionIsInverse = round(random(0, 1)) == 1 && allowAnswerAsQuestion;
        break;
      }
    }
    selected = true;
}

//Returns whether the quiz has ended
boolean startNewRound() {
  boolean temp = true;
  //Check if the quiz should be over
  for (int i = 0; i < answRight.length; i++) {
    if (!answRight[i]) {
      temp = false;
      asked = new boolean[q.length];
      break;
    }
  }
  return temp;
}
