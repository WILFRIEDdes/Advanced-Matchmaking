from django.urls import path

from . import views

urlpatterns = [
    path("", views.index, name="index"),
    path("projet/", views.projet, name="projet"),
    path("equipe/", views.equipe, name="equipe"),
    path("objectif/", views.objectif, name="objectif"),
    path("contact/", views.contact, name="contact"),
]