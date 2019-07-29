defmodule Worlock.Browser do

  @path "/media/Ze_Mada/Movies"
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

  def rename(name) do
    location = Path.join(@path, name)
    IO.puts location
    File.rename(location, Path.join(@path, "Hurricane Season 2009"))
  end

end
