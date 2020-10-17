import std.stdio;
import std.net.curl;
import image;
import std.json;
import std.conv: to;
import std.string;
import core.time;
import core.thread.osthread;
import std.process: execute;

int main(string[] args)
{
  string user;
  if (args.length > 1)
     user = args[1];
  else
     user = "CodeLongAndPros";
  auto stty = execute(["stty", "size"]);
  const int width = to!int(split(chomp(stty.output), " ")[1]);
  void print(string str) {
    writeln(center(str, width));
  }
  const string route = "https://profileapi.codelongandpros.repl.co/info";
  char[] data;
  JSONValue json;
  data = get(route ~ "?user=" ~ user);
  if (data == "")
    {
      writeln(format("Sorry, no user @%s", user));
      return 1; 
    }
  json = parseJSON(to!string(data));

  string name = json["name"].str;
  string bio =  json["bio"].str;
  int cycles = cast(int) json["cycles"].integer;
  string profile = json["profile"].str;
  string username = json["username"].str;
  auto repls = json["repls"].array;
  auto roles = json["roles"].array;
  
  print(name);
  Thread.sleep( dur!("msecs")( 100 ) );
  print(username);
  Thread.sleep( dur!("msecs")( 100 ) );
  print(bio);
  Thread.sleep( dur!("msecs")( 100 ) );
  print(format("%d cycles", cycles));
  Thread.sleep( dur!("msecs")( 100 ) );
  print("First 5 repls:");
  Thread.sleep( dur!("msecs")( 100 ) );
  foreach(JSONValue repl; repls){
    print("https://" ~ repl.str);
    Thread.sleep( dur!("msecs")( 100 ) );
  }
  foreach(JSONValue role; roles) {
    switch(role.str) {
    case "moderator":
      writeln("\u001b[34m");
      print("Moderator");
      writeln("\u001b[0m");
      break;
    case "content_creator":
      writeln("\u001b[33m");
      print("Content Creator");
      writeln("\u001b[0m");
      break;
    case "detective":
      writeln("\u001b[32m");
      print("Detective");
      writeln("\u001b[0m");
      break;
    default:
      print("No roles :(");
      break;
    }
  }

  disp(profile);
  return 0;
}
