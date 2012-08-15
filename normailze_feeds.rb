def normalize(s)
    s.downcase.gsub(/[ä]/, "ae").gsub(/[ö]/, "oe").gsub(/[ü]/,   "ue").gsub(/[ß]/, "ss").gsub(/[^a-zA-Z\ ]/,"").split
end
