#Para manejar archivos en repositorios tarea 1 

library(tidyverse)
library(ghclass)

Roster <- read.csv("roster_seed707.csv")


github_set_token("8030afbb3ac5faee560484a9607e6823c3b00d5e")


#repo_delete(paste0("Tarea_1_review-", Roster$user))


#Detectar los archivos de los autores de tareas
repo_ls(repo= "BIO4022/Tarea_1_GiorgiaGraells",  full_path = TRUE)


# Obtener la tarea del autor
A <- repo_get_file(
  repo = "BIO4022/Tarea_1_GiorgiaGraells",
  path = "tarea1.Rmd",
  branch = "master",
  quiet = FALSE,
  include_details = TRUE
)

# Poner la tarea en el revisor
repo_put_file(
  repo="BIO4022/Tarea_1review-derek-corcoran-barrios",
  path= "aut1/tarea1.Rmd",
  content=A,
  message = "Subiendo tarea 1",
  branch = "master",
  verbose = TRUE
)

####NicolasGatica

Usuario <- "NicolasGatica"
#Detectar los archivos de los autores de tareas
Archivos <- repo_ls(repo= paste0("Curso-programacion/Tarea_1_",Usuario),  full_path = TRUE)
Archivos <- Archivos[!str_detect(Archivos,".rds")]
#repo_ls(repo="BIO4022/Tarea_1review-derek-corcoran-barrios",  path="aut1", full_path = TRUE)

# Obtener la tarea del autor

Archivos_listos <- list()
for(i in 1:length(Archivos)){
  try({
    Archivos_listos[[i]] <- repo_get_file(
    repo = paste0("Curso-programacion/Tarea_1_",Usuario),
    path = Archivos[i],
    branch = "master",
    quiet = FALSE,
    include_details = TRUE
  )})
}


Autor <- Roster %>% dplyr::filter(user == Usuario) %>% mutate(user_random = paste0(user_random, "/")) %>% pull(user_random)

Revisores <- Roster %>% dplyr::filter(user == Usuario) %>% dplyr::select(rev1, rev2, rev3) %>% pivot_longer(cols = everything()) %>% pull(value) %>% as.character()

Revisores_nombres <- Roster %>% dplyr::filter(user_random %in% Revisores) %>% pull(user) %>% as.character()

Repos_rev <- paste0("BIO4022/Tarea_1_review-", Revisores_nombres)

# Poner la tarea en el revisor



for(i in 1:length(Repos_rev)){
  for(j in 1:length(Archivos_listos)){
    repo_put_file(
      repo=Repos_rev[i],
      path= paste0(Autor, Archivos[j]),
      content=Archivos_listos[[j]],
      message = "Subiendo tarea 1",
      branch = "master",
      verbose = TRUE
    )
  }
}



###########tarea 3

Personas <- ghclass::org_members("Curso-programacion")
Faltantes <- org_pending("Curso-programacion")
Admin <- org_admins("Curso-programacion")

Todos <- c(Personas, Faltantes)
Estudiantes <- Todos[!(Todos %in% Admin)]


ghclass::org_create_assignment(
  org = "Curso-programacion",
  user = Estudiantes,
  repo = paste0("Tarea_3_", Estudiantes),
  team = NULL,
  source_repo = "Curso-programacion/Tarea_3",
  private = TRUE
)


#############
# Obtener peer review

RevTarea1 <- peer_score_review(org = "Curso-programacion",
                               roster = Roster,
                               form_review = "Evaluacion.Rmd",
                               prefix = "Tarea_1_",
                               suffix = "",
                               write_csv = TRUE
)
  
  
  
  


