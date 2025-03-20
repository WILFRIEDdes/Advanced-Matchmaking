from Models.user import User
from Models.project import Project
from typing import List

def score_users(users: List[User], project: Project) -> List[User]:
    for user in users:
        score = 0
        weight_skills = 0.5
        weight_experience = 0.3
        weight_preferences = 0.2

        # Skills scoring
        for skill, details in project.required_skills.items():
            if skill in user.skills and user.skills[skill] == details["level"]:
                score += weight_skills

        # Experience scoring
        if user.experience["years"] >= project.experience_criteria["years"]:
            score += weight_experience * 0.5
        if user.experience["projects"] >= project.experience_criteria["projects"]:
            score += weight_experience * 0.5

        # Preferences scoring
        for pref in user.preferences.get("positive", []):
            if pref in project.bonus_skills:
                score += weight_preferences * 0.5
        for pref in user.preferences.get("negative", []):
            if pref in project.bonus_skills:
                score -= weight_preferences * 0.5

        user.score = min(1, max(0, score))  # Ensure score is between 0 and 1
    return users
