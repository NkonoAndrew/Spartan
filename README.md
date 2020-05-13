# :hatching_chick: SpartenNet 
## Introduction

"SpartanNet" is a social event app design for SJSU students. It developed on the
IOS platform, and it is written in Swift. It helps SJSU students to discover
popular events, activities, clubs on campus. Also, it allows students to post
events, create casual meetups, arrange social activities, and stay informed with
the latest event updates.

## App Features 
- Sign up: allow users to sign up through Email 
- Sign in: allow users to sign into the app through Email, Gmail and Facebook 
- Post   : allow users to post event name, event date and event details to the database 
- Contact: allow users to send feedback to the developers 
- Profile: Display user's profile photo, name, and major
- Edit   : allow users to edit the profile photo, name and major 
- Log out: allow users to log out the app 
- Detele : allow user to delete their account 


## Testing Instructions
### Phase 1: Set up Environment 
#### SpartanNet is developed in Swift, Xcode (Version 11.4.1 (11E503a)), MacBook Pro. The simulor is iPhone 11 Pro Max.
### Phase 2: Install Pod file 
#### Open a terminal window on Mac, and $cd into the current SpartanNet directory. Then install Pod file by running command $pod install,then open project folder, run project name "SparntanNet.xcworkspace". 
### Phase 3: Running the tests
#### Step 1: Testing Sign up and Login in 
- When SpartanNet is running on Xcode, it will shows the ViewController, it shows “Sign up”, “Login”, “Facebook sign in”, “google sign in” .The testing can use all the sign in methods. I suggest using “Sign up” by
creating an account with Email and password, the password format is length
at least 8 characters and at least one capital letter. The password example can
be: 123456AA.

#### Step 2: Testing Post functionlity 
- After Login into SpartanNet, the tab bar homeview page will show on the
SpartanNet, click “post” in the bottom, then fill up information of
an event in the post view page, then click right bar item “post”. The data will
be store in the database.
#### Step 3: Testing Contact functionlity 
- It is the same process as testing “Post” functionality, navigate to Contact
page, fill up the information then submit.
#### Step 4: Testing Edit Profile functionlity 
- Navigate to Profile- > Edit-> Edit Profile Page, then it
change the photo, name and Major.
#### Step 5: Check Database 
- When you enter to Firebase console, click on the left side “Authentication”, you will see all the
authenticated users. Then go to Database, you will see the three collections, “Feedback”, “Posts”
and “Users”. “Database” is the place to store all users and events’ data from users’ input. “Storage” is the place to store all the photos from the user’s upload.
#### Step 6: Testing Delete functionlity 
- The “Delete” button is in the bottom “Edit Profile” page, click that, it will
gives you two options “I’ll stay” and “Detele”, click on “Detele”, it will delete the user’s
account and bring the user back to launch page.
