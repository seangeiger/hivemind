# -*- coding: utf-8 -*-
# Generated by Django 1.11.1 on 2017-10-29 09:31
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0004_profile_transfer_request'),
    ]

    operations = [
        migrations.AddField(
            model_name='profile',
            name='not_invested',
            field=models.BooleanField(default=True),
        ),
    ]
