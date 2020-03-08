class Genre {
  static Map<String, String> genres = {
    "10759": "Acción y Aventura",
    "16": "Animación",
    "35": "Comedia",
    "80": "Crimen",
    "99": "Documentales",
    "18": "Drama",
    "12": "Aventura",
    "14": "Fantasía",
    "28": "Acción",
    "27": "Horror",
    "10751": "Familiar",
    "10762": "Infantiles",
    "9648": "Mysterio",
    "10763": "Nuevos",
    "10764": "Realidad",
    "10765": "Fantasía y Sci-Fi",
    ":10766": "Soap",
    "10767": "Talk",
    "10768": "Políticas",
    "37": "Oeste",
    "36": "Historia",
    "10402": "Musicales",
    "10749": "Romanticas",
    "878": "Ciencia Ficción",
    "10770": "Películas de TV",
    "53": "Thriller",
    "10752": "Bélicas",
    "37": "Western"
  };

  static String getGenre(String id) {
    return genres[id];
  }
}