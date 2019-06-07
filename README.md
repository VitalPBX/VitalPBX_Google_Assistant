VitalPBX Assistant, Powered by Google
=====

Below we will show step by step how to integrate Google Assistant in VitalPBX. For this integration, a little technical knowledge and an account in Google Cloud is required to access the Google Assitant API.

## Requirements<br>
client_secret_client-id.json<br>
project-id<br>
device-model-id<br>

To obtain these three requirements the following is necessary<br>

1.- Open the Actions Console.
https://console.actions.google.com/

2.- Click on Add/import project.

3.- To create a new project, type a name in the Project name box and click CREATE PROJECT.

4.- If you created a new project, click the Device registration box near the bottom of the page. If you imported a previously-created project, this box will not be displayed; select the Device registration tab (under ADVANCED OPTIONS) from the left navbar.

Keep this browser tab open. You will use it to register a device model in a later step.

5.- Enable the Google Assistant API on the project you selected (see the Terms of Service). You need to do this in the Cloud Platform Console.
https://console.developers.google.com/apis/api/embeddedassistant.googleapis.com/overview

6.- You must configure the OAuth consent screen for your project in the Cloud Platform Console. Note that most fields on this page are optional.
https://console.developers.google.com/apis/credentials/consent

Application type: Internal<br>
Application name: (The name of the app asking for consent, you can leave the default name)<br>
Application logo: (optional)<br>
Support email: (Select your email)<br>

Save<br>

Set activity controls for your account
In order to use the Google Assistant, you must share certain activity data with Google. The Google Assistant needs this data to function properly; this is not specific to the SDK.

Open the Activity Controls page for the Google account that you want to use with the Assistant. You can use any Google account, it does not need to be your developer account.
https://myaccount.google.com/activitycontrols

Ensure the following toggle switches are enabled (blue):

•	Web & App Activity
o	In addition, be sure to select the Include Chrome history and activity from sites, apps, and devices that use Google services checkbox.
•	Device Information
•	Voice & Audio Activity

## Register the Device Model<br>

Use the registration UI
Use the registration UI in the Actions Console to register a device model.
https://console.actions.google.com/

Click the REGISTER MODEL button.

Create model
Fill out all of the fields for your device. Select any device type, such as Light.

See the device model JSON reference for more information on these fields.

When you are finished, click REGISTER MODEL.

Download client_secret_<client-id>.json. Click NEXT.

Later, you will specify the different abilities that your device supports on this screen. But for now, click the SKIP button.

Copy this file (client_secret_<client-id>.json) in VitalPBX Server /var/lib/asterisk

## Install the SDK and Sample Code<br>
[root@vitalpbx /]# yum install python-devel python-virtualenv
[root@vitalpbx /]# virtualenv env --no-site-packages
[root@vitalpbx /]# env/bin/python -m pip install --upgrade pip setuptools wheel
[root@vitalpbx /]# source env/bin/activate

Install the package's system dependencies<br>
(env) [root@vitalpbx /]# yum install portaudio-19 libffi-devel openssl-devel libmpg123-devel
(env) [root@vitalpbx /]# python -m pip install --upgrade google-assistant-library==1.0.1
(env) [root@vitalpbx /]# python -m pip install --upgrade google-assistant-sdk[samples]==0.5.1

## Generate credentials<br>

(env) [root@vitalpbx /]# python -m pip install --upgrade google-auth-oauthlib[tool]

(env) [root@vitalpbx /]# google-oauthlib-tool --scope https://www.googleapis.com/auth/assistant-sdk-prototype --scope https://www.googleapis.com/auth/gcm --save --headless --client-secrets /var/lib/asterisk/client_secret_<client-id>.json

You should see a URL displayed in the terminal:

Please visit this URL to authorize this application: https://...

Copy the URL and paste it into a browser (this can be done on any machine). The page will ask you to sign in to your Google account. Sign into the Google account that created the developer project in the previous step.

After you approve the permission request from the API, a code will appear in your browser, such as "4/XXXX". Copy and paste this code into the terminal:

Enter the authorization code:

If authorization was successful, you will see a response similar to the following:

credentials saved: /root/.config/google-oauthlib-tool/credentials.json

Move the credential file to /var/lib/asterisk/:
mv /root/.config/google-oauthlib-tool/credentials.json /var/lib/asterisk/

## Run the Sample Code<br>

Copy google.agi file
[root@vitalpbx /]# cd /var/lib/asterisk/agi-bin
[root@vitalpbx agi-bin]# wget https://raw.githubusercontent.com/VitalPBX/VitalPBX_Google_Assistant/master/google.agi
[root@vitalpbx agi-bin]# chown asterisk:asterisk google.agi







