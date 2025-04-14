from django.urls import path

from . import views

urlpatterns = [
    path("", views.index, name="index"),
    path("login/", views.login_view, name="login"),
    path("first_login/", views.first_login, name="first_login"),
    path('unauthorized/', views.unauthorized, name='unauthorized'),
    path('generation_equipe/', views.generation_equipe, name='generation_equipe'),
    path('liste_employes/', views.liste_employes, name='liste_employes'),
    path('liste_projets/', views.liste_projets, name='liste_projets'),
]