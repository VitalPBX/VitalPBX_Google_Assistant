VitalPBX Assistant, Powered by Google
=====

Below we will show step by step how to integrate Google Assistant in VitalPBX. For this integration, a little technical knowledge and an account in Google Cloud is required to access the Google Assitant API.

## Requirements<br>
client_secret_client-id.json<br>
project-id<br>
device-model-id<br>

To obtain these three requirements the following is necessary<br>

1.- Open the Actions Console.<br>
https://console.actions.google.com/

2.- Click on Add/import project.<br>

3.- To create a new project, type a name in the Project name box and click CREATE PROJECT.<br>

4.- If you created a new project, click the Device registration box near the bottom of the page. If you imported a previously-created project, this box will not be displayed; select the Device registration tab (under ADVANCED OPTIONS) from the left navbar.<br>

Keep this browser tab open. You will use it to register a device model in a later step.<br>

5.- Enable the Google Assistant API on the project you selected (see the Terms of Service). You need to do this in the Cloud Platform Console.<br>
https://console.developers.google.com/apis/api/embeddedassistant.googleapis.com/overview<br>

6.- You must configure the OAuth consent screen for your project in the Cloud Platform Console. Note that most fields on this page are optional.<br>
https://console.developers.google.com/apis/credentials/consent<br>

Application type: Internal<br>
Application name: (The name of the app asking for consent, you can leave the default name)<br>
Application logo: (optional)<br>
Support email: (Select your email)<br>

Save<br>

Set activity controls for your account<br>
In order to use the Google Assistant, you must share certain activity data with Google. The Google Assistant needs this data to function properly; this is not specific to the SDK.<br>

Open the Activity Controls page for the Google account that you want to use with the Assistant. You can use any Google account, it does not need to be your developer account.<br>
https://myaccount.google.com/activitycontrols<br>

Ensure the following toggle switches are enabled (blue):<br>

•	Web & App Activity<br>
o	In addition, be sure to select the Include Chrome history and activity from sites, apps, and devices that use Google services checkbox.<br>
•	Device Information<br>
•	Voice & Audio Activity<br>

## Register the Device Model<br>

Use the registration UI<br>
Use the registration UI in the Actions Console to register a device model.<br>
https://console.actions.google.com/<br>

Click the REGISTER MODEL button.<br>

Create model<br>
Fill out all of the fields for your device. Select any device type, such as Light.<br>

See the device model JSON reference for more information on these fields.<br>

When you are finished, click REGISTER MODEL.<br>

Download client_secret_<client-id>.json. Click NEXT.<br>

Later, you will specify the different abilities that your device supports on this screen. But for now, click the SKIP button.<br>

Copy this file (client_secret_<client-id>.json) in VitalPBX Server /var/lib/asterisk<br>

## Install the SDK and Sample Code<br>
<pre>
[root@vitalpbx /]# yum install python-devel python-virtualenv
[root@vitalpbx /]# virtualenv env --no-site-packages
[root@vitalpbx /]# env/bin/python -m pip install --upgrade pip setuptools wheel
[root@vitalpbx /]# source env/bin/activate
</pre>

Install the package's system dependencies<br>
<pre>
(env) [root@vitalpbx /]# yum install portaudio-19 libffi-devel openssl-devel libmpg123-devel
(env) [root@vitalpbx /]# python -m pip install --upgrade google-assistant-library==1.0.1
(env) [root@vitalpbx /]# python -m pip install --upgrade google-assistant-sdk[samples]==0.5.1
</pre>

## Generate credentials<br>
<pre>
(env) [root@vitalpbx /]# python -m pip install --upgrade google-auth-oauthlib[tool]

(env) [root@vitalpbx /]# google-oauthlib-tool --scope https://www.googleapis.com/auth/assistant-sdk-prototype --scope https://www.googleapis.com/auth/gcm --save --headless --client-secrets /var/lib/asterisk/client_secret_<client-id>.json
</pre>

You should see a URL displayed in the terminal:<br>

Please visit this URL to authorize this application: https://...<br>

Copy the URL and paste it into a browser (this can be done on any machine). The page will ask you to sign in to your Google account. Sign into the Google account that created the developer project in the previous step.<br>

After you approve the permission request from the API, a code will appear in your browser, such as "4/XXXX". Copy and paste this code into the terminal:<br>

Enter the authorization code:<br>

If authorization was successful, you will see a response similar to the following:<br>

credentials saved: /root/.config/google-oauthlib-tool/credentials.json<br>

Move the credential file to /var/lib/asterisk/:<br>
<pre>
[root@vitalpbx /]# mv /root/.config/google-oauthlib-tool/credentials.json /var/lib/asterisk/
</pre>

## Run the Sample Code<br>

Copy google.agi file<br>
<pre>
[root@vitalpbx /]# cd /var/lib/asterisk/agi-bin
[root@vitalpbx agi-bin]# wget https://raw.githubusercontent.com/VitalPBX/VitalPBX_Google_Assistant/master/google.agi
[root@vitalpbx agi-bin]# chown asterisk:asterisk google.agi
</pre>

## GET project-id and device-model-id<br>

Goto Actions on Google<br>
https://console.actions.google.com/u/0/<br>
Select the project<br>
Device Registration<br>
Select REGISTER MODEL from the list<br>
Copy de model ID<br>
Now goto project settings (in the menu press the Setting Icon)<br>
Copy the Project ID<br>

Now edit the google.agi file a replace this two value<br>
<pre>
[root@vitalpbx agi-bin]# vi google.agi
# Google Project ID             #
my $projectid = "your-project-id";

# Google Device Model ID        #
my $devicemodelid = "your-device-model-id";

# ----------------------------- #
</pre>

## Load Example code<br>

<pre>
[root@vitalpbx ]#  cd /etc/asterisk/ombutel
[root@vitalpbx ombutel]#  wget https://raw.githubusercontent.com/VitalPBX/VitalPBX_Google_Assistant/master/extensions__60-google_assistant.conf
[root@vitalpbx ombutel]#  asterisk -rx”dialplan reload”
[root@vitalpbx ombutel]#  cd /var/lib/asterisk/sounds/en
[root@vitalpbx en]# wget https://github.com/VitalPBX/VitalPBX_Google_Assistant/blob/master/google_another.sln
[root@vitalpbx en]# wget https://github.com/VitalPBX/VitalPBX_Google_Assistant/blob/master/google_example.sln
[root@vitalpbx en]# wget https://github.com/VitalPBX/VitalPBX_Google_Assistant/blob/master/google_goodbye.sln
[root@vitalpbx en]# wget https://github.com/VitalPBX/VitalPBX_Google_Assistant/blob/master/google_wait.sln
[root@vitalpbx en]# wget https://github.com/VitalPBX/VitalPBX_Google_Assistant/blob/master/google_welcome.sln
[root@vitalpbx en]# mkdir /var/lib/asterisk/.config/
[root@vitalpbx en]# chown asterisk:asterisk /var/lib/asterisk/.config/
</pre>

## Test your installation<br>
From any phone in you PBX dial: *789<br>














