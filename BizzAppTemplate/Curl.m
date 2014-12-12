//
//  Curl.m
//  BizzAppTemplate
//
//  Created by Christian Vazquez on 7/20/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "Curl.h"

@implementation Curl

+(void)SendCurlPost{
    
    NSString *name=@"Juan del pueblo";
    NSString *email=@"jpueblo@gmail.com";
    NSString *phone=@"000-000-0000";
    NSString *subject=@"TEST CURL";
    NSString *message=@"TEST MESSAGE CURL";
    NSString *ip=@"0.0.0.0";
  //  NSMutableArray *attachments;
    
 
    
    NSString *jsonBody = [NSString stringWithFormat:@"{\"name\":\"%@\",\"email\":\"%@\",\"phone\":\"%@\",\"subject\":\"%@\",\"message\":\"%@\",\"ip\":\"%@\",\"attachments\":\"%@\"}",name,email,phone,subject,message,ip,@""];
    
    
    NSString *json = [NSString stringWithFormat:@"{\"alert\":true,\"autorespond\": true,\"source\": \" 62074515A8904C251C94657659084249\",\"name\": \"Angry User\",\"email\": \"api@osticket.com\",\"phone\":\"3185558634X123\",\"subject\": \"Testing API\",\"ip\": \"0.0.0.0\",\"message\": \"MESSAGE HERE\",\"attachments\":\"\" }"];
    
    
    
    // Make a call to the API to pull out the categories
    NSURL *url = [NSURL URLWithString:@"http://www.gismarttechnologies.com/helpdesk/upload/api/http.php/tickets.json"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    // Create the username:password string for the request
 //   NSString *loginString = nil;//[NSString stringWithFormat:@"%@:%@", API_USERNAME, API_PASSWORD];
    
    // Create the authorisation string from the username password string
    NSData *postData = [json dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSError *error;
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
   
    NSLog(@"Data: %@",data);
    NSLog(@"Request: %@",request);
    NSLog(@"Response: %@",response);
    NSLog(@"Error: %@",error);
    
    
    
}



/*

 DATA JSON Example.
 
 $data = array(
 'name'      =>      'John Doe',  // from name aka User/Client Name
 'email'     =>      'john@gmail.com',  // from email aka User/Client Email
 'phone' 	=>		'1234567890',  // phone number aka User/Client Phone Number
 'subject'   =>      'Test API message',  // test subject, aka Issue Summary
 'message'   =>      'This is a test of the osTicket API',  // test ticket body, aka Issue Details.
 'ip'        =>      $_SERVER['REMOTE_ADDR'], // Should be IP address of the machine thats trying to open the ticket.
 //'Agency'  =>		'58', //this is an example of a custom list entry. This should be the number of the entry.
 //'Site'	=>		'Bermuda'; // this is an example of a custom text field.  You can push anything into here you want.
 'attachments' => array()
 );
 
 */


/*
 
PHP CURL POST EXAMPLE
 
 #curl post
 $ch = curl_init();
 curl_setopt($ch, CURLOPT_URL, $config['url']);
 curl_setopt($ch, CURLOPT_POST, 1);
 curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
 curl_setopt($ch, CURLOPT_USERAGENT, 'osTicket API Client v1.8');
 curl_setopt($ch, CURLOPT_HEADER, FALSE);
 curl_setopt($ch, CURLOPT_HTTPHEADER, array( 'Expect:', 'X-API-Key: '.$config['key']));
 curl_setopt($ch, CURLOPT_FOLLOWLOCATION, FALSE);
 curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
 $result=curl_exec($ch);
 $code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
 curl_close($ch);
 
 if ($code != 201)
 die('Unable to create ticket: '.$result);
 
 $ticket_id = (int) $result;
 
 */


@end
