
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


boolean[] asked = new boolean[q.length];
boolean[] answRight = new boolean[q.length];

String nowWriting = "";
boolean selected = false;
int selection;
void draw() {  
  if (!selected) {
    //There is no question being answered ---> select a new one.
    //Check if any unasked questions are left
    boolean questionsLeft = false;
    for (int i = 0; i < asked.length; i++) {
      if (!asked[i]) {
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
        background(0);
        fill(255, 0, 0);
        textSize(30);
        text("Quiz over!", 20, 50);
        noLoop();
        return;
      }
    }
  } else {
    //A question is selected. Draw it, and check for completion
    
  }
}

boolean enterPressed;
void keyPressed() {
  enterPressed = keyCode == ENTER && keyCode == RETURN;
  if (!enterPressed) {
    if (keyCode == BACKSPACE) {
      nowWriting = nowWriting.substring(0, nowWriting.length() - 1);
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
      if(!asked[index]) {
        selection = index;
        break;
      }
    }
    selected = true;
}

//Returns whether the quiz has ended
boolean startNewRound() {
  boolean quizOver = false;
  //Check if the quiz should be over
  for (int i = 0; i < answRight.length; i++) {
    if (!answRight[i]) {
      quizOver = true;
      asked = new boolean[q.length];
      break;
    }
  }
  return quizOver;
}
