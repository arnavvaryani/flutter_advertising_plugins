package com.anavrinapps.trsurveys;

import io.flutter.Log;

import theoremreach.com.theoremreach.TheoremReach;
import theoremreach.com.theoremreach.TheoremReachRewardListener;
import theoremreach.com.theoremreach.TheoremReachSurveyAvailableListener;
import theoremreach.com.theoremreach.TheoremReachSurveyListener;

public class Listeners implements TheoremReachRewardListener, TheoremReachSurveyAvailableListener, TheoremReachSurveyListener {
 
   @Override
    public void onRewardCenterClosed() {
      Log.i("TheoremReach", "onRewardCenterClosed");
        TrsurveysPlugin.getInstance().OnMethodCallHandler("onRewardCenterClosed",0);
    }

     @Override
    public void onRewardCenterOpened() {
        Log.i("TheoremReach", "onRewardCenterOpened");
        TrsurveysPlugin.getInstance().OnMethodCallHandler("onRewardCenterOpened",0);
    }

 @Override
    public void onReward(final int quantity) {
        Log.i("TheoremReach", "onRewardCenterOpened");
        TrsurveysPlugin.getInstance().OnMethodCallHandler("onReward", quantity);
    }

 @Override
    public void theoremreachSurveyAvailable(final boolean surveyAvailable) {
        int survey = 0;
        if(surveyAvailable) {
            survey = 1;
        } else if (!surveyAvailable) {
           survey = 0;
        }
        Log.i("TheoremReach", "theoremReachSurveyAvailable");
        TrsurveysPlugin.getInstance().OnMethodCallHandler("theoremReachSurveyAvailable", survey); 
    }
}