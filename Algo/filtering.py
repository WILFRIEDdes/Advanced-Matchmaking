from Models.user import User
from Models.project import Project
from typing import List

def filter_users(users: List[User], project: Project) -> List[User]:
    filtered_users = []
    for user in users:
        if user.hourly_rate * 8 <= project.budget and user.mobility in [project.mobility, "both"]:
            if all(skill in user.skills and user.skills[skill] == project.required_skills[skill]["level"] 
                   for skill in project.required_skills):
                filtered_users.append(user)
    return filtered_users
