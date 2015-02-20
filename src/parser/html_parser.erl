%% @ Author : Scott Birkett
%%

-module(html_parser).

-export([parse_battle_scribe_to_xml/1]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  API Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

parse_battle_scribe_to_xml(File)->
    html_file_parser(File).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Internal Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

html_file_parser(File)->
    % Read file
    Raws = read(File),
    Cleans = clean_file(Raws),
    {ParseResults,_} = xmerl_scan:string(Cleans),
    ParseResults.

clean_file(Lines)->
    % Remove <br>
    % Remove <br/>
    % Remove all <head>.*</head>
    % Wrap in <xml></xml>
    MutA = re:replace(Lines,"<html>","",[global,{return,list}]),
    MutB = re:replace(MutA,"</html>","",[global,{return,list}]),
    MutC = re:replace(MutB,"<br>","",[global,{return,list}]),
    MutD = re:replace(MutC,"<br/>","",[global,{return,list}]),
    MutE = re:replace(MutD,"<head>.+</head>","",[global,{return,list},dotall]),
    "<xml>" ++ MutE ++ "</xml>".

read(N) ->
    {ok,Data} = file:read_file(N),
    Data.
