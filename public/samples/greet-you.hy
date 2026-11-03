public class Program {
    public static int Main(string[] args) {
        string name = "friend";
        if (args.Length > 0) {
            name = args[0];
        }
        System.Console.WriteLine("Hello, " + name + "!");
        return 0;
    }
}
