// [START sheets_quickstart]
const fs = require('fs');
const readline = require('readline');
const {google} = require('googleapis');

// If modifying these scopes, delete token.json.
const SCOPES = ['https://www.googleapis.com/auth/spreadsheets'];
// The file token.json stores the user's access and refresh tokens, and is
// created automatically when the authorization flow completes for the first
// time.
const TOKEN_PATH = 'token.json';


	/**
	* Create an OAuth2 client with the given credentials, and then execute the
	* given callback function.
	* @param {Object} credentials The authorization client credentials.
	* @param {function} callback The callback to call with the authorized client.
	*/
	function authorize(credentials, callback) {
		const {client_secret, client_id, redirect_uris} = credentials.installed;
		const oAuth2Client = new google.auth.OAuth2(client_id, client_secret, redirect_uris[0]);

		// Check if we have previously stored a token.
		fs.readFile(TOKEN_PATH, (err, token) => {
			if (err) return getNewToken(oAuth2Client, callback);
			//console.log(token.toString())
			oAuth2Client.setCredentials(JSON.parse(token));
			 // Validate the token
			oAuth2Client.getAccessToken((err, token) => {
				if (err) {
					console.error('Error checking access token:', err);
					return getNewToken(oAuth2Client, callback);
				}
				callback(oAuth2Client);
			});
		});
	}
	/**
	* Get and store new token after prompting for user authorization, and then
	* execute the given callback with the authorized OAuth2 client.
	* @param {google.auth.OAuth2} oAuth2Client The OAuth2 client to get token for.
	* @param {getEventsCallback} callback The callback for the authorized client.
	*/
	function getNewToken(oAuth2Client, callback) {
		const authUrl = oAuth2Client.generateAuthUrl({
			access_type: 'offline',
			scope: SCOPES,
		});
		console.log('Authorize this app by visiting this url:', authUrl);
		const rl = readline.createInterface({
			input: process.stdin,
			output: process.stdout,
		});
		rl.question('Enter the code from that page here: ', (code) => {
			rl.close();
			oAuth2Client.getToken(code, (err, token) => {
				if (err) return console.error('Error while trying to retrieve access token', err);
				oAuth2Client.setCredentials(token);
				// Store the token to disk for later program executions
				fs.writeFile(TOKEN_PATH, JSON.stringify(token), (err) => {
					if (err) return console.error(err);
					console.log('Token stored to', TOKEN_PATH);
				});
				callback(oAuth2Client);
			});
		});
	}
	async function addRows(sheets, spreadsheetId, range, values) {
		return new Promise((resolve) => {
			const resource = {values};
			let valueInputOption = "RAW"
			sheets.spreadsheets.values.update({
				spreadsheetId,
				range,
				valueInputOption,
				resource,
			}, (err, result) => {
				if (err) {
					// Handle error
					console.log(err);
					throw err;
				} else {
					resolve();
					// console.log("update:%s range:%s cells updated:%s", spreadsheetId, range, result.updatedCells);
				}
			});
		});

	}
	async function clear(sheets, auth, spreadsheetId, range) {
		return new Promise((resolve) => {
			let request = {
				spreadsheetId: spreadsheetId,
				range: range,
				auth: auth,
			};
			sheets.spreadsheets.values.clear(request, function (err, response) {
				if (err) {
					throw err;
				} else {
					console.log("clear:" + spreadsheetId + " " + range);
					resolve();
				}
			});
		})
	}
	async function get(sheets,auth,spreadsheetId,range){
		return new Promise((resolve) => {
			let request = {
				spreadsheetId: spreadsheetId,
				range: range,
				auth: auth,
			};
			
			sheets.spreadsheets.values.get(request, (err, res) => {
				if (err) {
					throw err;
				} else {
					console.log("get:" + spreadsheetId + " " + range);
					const rows = res.data.values;
					if (!rows || !rows.length) {
						console.log('No data found.');
					}
					resolve(rows);
				}
				
			});
		});
		

	}
module.exports = {
	authorize:authorize,
	getNewToken:getNewToken,
	addRows:addRows,
	clear:clear,
	get:get
}