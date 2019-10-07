defmodule Worlock.Browser do
  use GenServer
  alias Worlock.TMDB
  @path "/Users/munya/Desktop/test"

  def start_link(name) when is_binary(name), do:
    GenServer.start_link(__MODULE__, name, [])

  def handle_info(:first, state) do
    IO.puts "Howdy"
    {:noreply, state}
  end

  def handle_call(:demo_call, _from, state) do
    {:reply, state, state}
  end

  def fixedEmUp() do
    getFolders()
    |> Enum.map(fn f -> gtf(Path.join(@path, f)) end)
  end

  def gtf(folder) do
    IO.puts folder
    [head | _tail] = File.ls!(folder)
                     |> Enum.filter(fn f -> !File.dir?(Path.join(folder, f))
                     end)
    IO.puts head

    case getName(head) do
      {:ok, title} ->
        IO.puts title
        # ext = Path.extname(head)
        # rename(Path.join(folder, head), Path.join(folder, title <> ext))
      {:error, msg} ->
        IO.puts msg
    end
  end

  def getFolders() do
    File.ls!(@path)
    |> Enum.filter(fn f -> File.dir?(Path.join(@path, f))
    end)
  end

  def getFiles() do
    File.ls!(@path)
    |> Enum.filter(fn f -> !File.dir?(Path.join(@path, f))
    end)
  end

  def getFiles(type) do
    File.ls!(@path)
    |> Enum.filter(fn f -> !File.dir?(Path.join(@path, f))
    end)
    |> Enum.filter(fn f -> Path.extname(f) == type
    end)
  end

  def createFolder(name) do
    path = Path.join(@path, name)
    File.exists?(path)
    |> File.mkdir(path)
  end

  def deleteFileByExt(ext) do
    getFiles(ext)
    |> Enum.map(fn f -> deleteFile(f) end)
  end

  def deleteFile(name) do
    File.rm(Path.join(@path, name))
  end

  def rename(og, new) do

    File.rename(og, new)
  end

  def getName(name) do
    fixedName = removeKeywords(name)
                |> removeSquareBrackets
                |> removeBrackets
                |> removeWhiteSpace
                |> removeYear
                |> removeDots
                |> removeTrailingSpaces
                |> String.trim_trailing
    res = TMDB.search(fixedName)

    case Map.get(res, "Response") do
      "False" ->
        {:error, Map.get(res, "Error")}
      "True" ->
        [head | _tail ] = Map.get(res, "Search")
        IO.inspect head
        j = Map.take(head, ["Title", "Year", "Type"])
        IO.inspect j
        {:ok, Map.get(head, "Title")}
    end
  end

  def removeKeywords(name) do
    bad = [ "720p","720","BluRay","x264","YIFY","mkv","1080p","mp4","BrRip","HDRip", "XviD","avi","AC3-EVO","XViD","ETRG","WEB-DL","x264","AAC",
            "Hon3y","DvDrip","AC3","aXXo","bitloks","iExTV","GB","ResourceRG","Bezauk","H264","actuality","Ozlem","DXVA","AAC","MXMG","Alliance",
            "i_c","6CH","x265","PSA","HEVC","GAZ","ESubs","MkvCage","DD5","1388kbps","Rapta","MultiSub","DOCU","Shaanig", "BRrip", "WEBRip", "BRRip",
            "idx", "bokutox", "sc0rp", "Ehhhh","Cage", "1-POOP", "1P00P", "srt", "muxed", "scOrp", "DTSJYK", "RARBG", "ESub", "Jayp53", "264",
            "anoXmous", "anoXmous", "IMAX", "Deceit", "Atilla82", "ExtraTorrentRG", "Pristine", "1CH", "Smallandhd", "Ganool", "Sujaidr", "Gwoemul",
      "FOXM", "HDTV", "xbox360fan", "ENSUB" ]
    Enum.uniq(bad)
    |> Enum.reduce(name, fn s, acc -> String.replace(acc, s, " ") end)
  end

  defp removeSquareBrackets(name) do
    Regex.replace(~r/(\[|{)(([a-zA-Z0-9]*)(\.|\s|-)?([a-zA-Z0-9]*)?)(\]|})/, name, " ")
  end

  defp removeTrailingSpaces(name) do
    String.replace(name, ~r/\s+/, " ")
  end

  defp removeDots(name) do
    String.replace(name, ".", " ")
  end

  defp removeYear(name) do
    Regex.replace(~r/(?:(?:19|20)[0-9]{2})/, name, " ")
  end

  def extractYear(name) do
    Regex.run(~r/(?:(?:19|20)[0-9]{2})/, name)
  end

  defp removeWhiteSpace(name) do
    Regex.replace(~r/\s+/, name, " ")
  end

  defp removeBrackets(name) do
    Regex.replace(~r/(\()[a-zA-Z]*(\))/, name, " ")
  end

end

