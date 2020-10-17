import std.process: execute, executeShell;
import std.stdio: writefln, File, writeln;
import std.uni: toLower;
import std.conv;
import std.string: chomp;
import std.path: expandTilde;
import std.file;
import std.net.curl;

string get_term()
{
  auto term = executeShell(`ps -o comm= -p "$(($(ps -o ppid= -p "$(($(ps -o sid= -p "$$")))")))"`);
  auto terminal = chomp(toLower(term.output));
  return terminal;


}
int kitty_disp_image(string image)
{
  auto kitty = execute(["kitty", "+kitten", "icat", image]);
  if (kitty.status != 0)
  {
    writefln("Error. %s %s exited with status %d", "kitty +kitten icat", image, kitty.status);
  }
  return 0;
}

void download_img(string url)
{
  download(url, "/tmp/profile.png");
}

bool image_disp()
{
  switch(get_term())
    {
    case "kitty": 
      return true;
    default:
      return false;
    }
}

void disp(string url)
{
  if (image_disp())
  {
    download_img(url);
    kitty_disp_image("/tmp/profile.png");
  }
  else
  {
    writeln("Sorry, in-line images are only supported in KiTTY.");
    writefln("Image is located at `%s`", url);
  }
}
