defmodule Metro_CDMX do
    defmodule Line do
     #defstruct name: "", stations: []
     defstruct [:name, :stations]
   end

   defmodule Station do
     defstruct [:name, :coords]
   end

    def metro do
        import SweetXml
        doc = File.read!("./data/Metro_CDMX.kml")

        nombre_lineas = doc 
        |> xpath(~x"//Document/Folder[1]/Placemark/name/text()"l) 
        |> Enum.map(fn l -> List.to_string(l) end)

        metro = nombre_lineas |> Enum.map(fn item ->
          stations = doc     
          |> xpath(~x"//Document/Folder[1]/Placemark[name=\"#{item}\"]/LineString/coordinates/text()"l)
          |> Enum.map(fn l -> List.to_string(l) end)
          |> List.first()
          |> String.split()
          |> Enum.map(fn item -> 
             
             %Station{
                 name: doc     
             |> xpath(~x"/kml/Document/Folder[2]/Placemark[contains(./Point/coordinates,\"#{item}\")]/name/text()"l)
             |> Enum.map(fn l -> List.to_string(l) end)
             |> List.first(), 
             coords: String.trim(item)
                } 
             end)
            %Line{name: item, stations: stations}       
        end)
        
        graph = Graph.new(type: :undirected)
         Enum.reduce(metro, graph, fn line, graph ->
            biStation = Enum.chunk_every(line.stations, 2, 1, :discard)
            Enum.reduce(biStation, graph, fn station, graph ->
                Graph.add_edge(graph, List.first(station).name, List.last(station).name)
            end)
          end)  
    end
end