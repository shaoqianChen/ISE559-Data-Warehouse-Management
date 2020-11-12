import itertools
import random
import pandas as pd
from pyomo.core import *
from pyomo.pysp.annotations import  PySP_ConstraintStageAnnotation
from pyomo.pysp.annotations import  PySP_StochasticRHSAnnotation

i = 0
f1 = pd.read_csv("data.csv")
d1_rhs_table = []
f = ''.join(open("Advertising1.csv").readlines())
d1_rhs_table = f.split(',')

num_scenarios = len(d1_rhs_table)
scenario_data = dict(('Scenario'+str(i),(d1val)) for i,(d1val) in enumerate(d1_rhs_table,1))

#Define the reference model

model = ConcreteModel()

model.constraint_stage = PySP_ConstraintStageAnnotation()
model.stoch_rhs = PySP_StochasticRHSAnnotation()

model.d1_rhs = Param(mutable = True, initialize = 0.0)

#first-stage variables
model.x1 = Var(bounds=(0.7,296.4))
model.x2 = Var(bounds=(0,49.6))

#second-stage variables
model.y1 = Var(within = NonNegativeReals)
model.y2 = Var(within = NonNegativeReals)

#Stage-cost expressions
model.FirstStageCost = Expression(initialize = (0.5*model.x1+0.2*model.x2))
model.SecondStageCost = Expression(initialize = (3*model.y1 + 5*model.y2))


# This model has two first-stage constraints

model.s1 = Constraint(expr = model.x1 + model.x2 <= 0)
model.constraint_stage.declare(model.s1,1)

model.s2 = Constraint(expr = model.x1 + model.x2 <= 200)
model.constraint_stage.declare(model.s2,1)

model.s3 = Constraint(expr = model.x1 + 0.7*model.x2 <= 0)
model.constraint_stage.declare(model.s3,1)

#this model has four second-stage constraints

model.s4 = Constraint(expr = model.y1 <=8)
model.constraint_stage.declare(model.s4,2)

model.s5 = Constraint(expr = 2*model.y2 <=24)
model.constraint_stage.declare(model.s5,2)

model.s6 = Constraint(expr = 3*model.y1+2*model.y2 <=36)
model.constraint_stage.declare(model.s6,2)

#These one constraints have stochastic right-hand-sides
model.d1 = Constraint(expr=3.146986251809624 + 0.04585391*model.x1+0.18412361*model.x2-model.y1-model.y2 >=-2.4366279726648816)
model.constraint_stage.declare(model.d1,2)
model.stoch_rhs.declare(model.d1)

#always define the objective as the sum of the stage costs
model.obj = Objective(expr=model.FirstStageCost + model.SecondStageCost)

def pysp_scenario_tree_model_callback():
    from pyomo.pysp.scenariotree.tree_structure_model import CreateConcreteTwoStageScenarioTreeModel
    st_model = CreateConcreteTwoStageScenarioTreeModel(num_scenarios)
    
    first_stage = st_model.Stages.first()
    second_stage = st_model.Stages.last()
    
    #First Stage
    st_model.StageCost[first_stage] = 'FirstStageCost'
    st_model.StageVariables[first_stage].add('x1')
    st_model.StageVariables[first_stage].add('x2')
    
    #Second Stage
    st_model.StageCost[second_stage] = 'SecondStageCost'
    st_model.StageVariables[second_stage].add('y1')
    st_model.StageVariables[second_stage].add('y2')
    
    return st_model

def pysp_instance_creation_callback(scenario_name,node_names):
    instance = model.clone()
    d1.rhs_val=scenario_data[scenario_name]
    instance.d1_rhs.value = d1_rhs_val
    return instance
    