# -*- coding: utf-8 -*-
# Generated by Django 1.11.5 on 2017-10-28 20:44
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Asset',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=10)),
                ('price', models.DecimalField(decimal_places=8, max_digits=15)),
                ('api_name', models.CharField(max_length=10)),
            ],
        ),
    ]
