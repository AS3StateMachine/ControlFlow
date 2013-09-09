package flow.impl
{
import flow.impl.support.ClassRegistry;
import flow.impl.support.cmds.MockCommandOne;
import flow.impl.support.cmds.MockCommandThree;
import flow.impl.support.cmds.MockCommandTwo;
import flow.impl.support.guards.GrumpyGuard;
import flow.impl.support.guards.HappyGuard;
import flow.impl.support.guards.JoyfulGuard;

import org.hamcrest.assertThat;
import org.hamcrest.collection.array;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.nullValue;
import org.hamcrest.object.strictlyEqualTo;
import org.swiftsuspenders.Injector;

public class OptionControlFlowTest implements ClassRegistry
{
    private var _classUnderTest:OptionalControlFlow;
    private var _injector:Injector;
    private var _parent:ControlFlow;
    private var _registeredClasses:Vector.<Class>;
    private var _executor:Executor;

    [Before]
    public function before():void
    {
        _registeredClasses = new Vector.<Class>();
        _injector = new Injector();
        _injector.map( ClassRegistry ).toValue( this );
        _parent = new ControlFlow( _injector );
        _executor = new Executor( _injector );

        _classUnderTest = new OptionalControlFlow( _parent, _executor );
    }

    [Test]
    public function and_property_returns_parent_mapping():void
    {
        assertThat( _classUnderTest.and, strictlyEqualTo( _parent ) );
    }

    [Test]
    public function or_property_returns_self():void
    {
        assertThat( _classUnderTest.or, strictlyEqualTo( _classUnderTest ) );
    }

    [Test]
    public function execute_returns_self():void
    {
        assertThat( _classUnderTest.executeAll(), strictlyEqualTo( _classUnderTest ) );
    }

    [Test]
    public function execute_maps_command_classes_to_currentCommandGroup_and_retains_order():void
    {
        _classUnderTest.executeAll( MockCommandOne, MockCommandThree, MockCommandTwo )
        assertThat( _classUnderTest.currentCommandGroup.commands,
                array(
                        strictlyEqualTo( MockCommandOne ),
                        strictlyEqualTo( MockCommandThree ),
                        strictlyEqualTo( MockCommandTwo )
                ) );
    }

    [Test]
    public function execute_pushes_currentCommandMap():void
    {
        _classUnderTest.executeAll( MockCommandOne, MockCommandThree, MockCommandTwo )
        assertThat( _classUnderTest.executionData[0], strictlyEqualTo( _classUnderTest.currentCommandGroup ) );
    }

    [Test]
    public function onApproval_returns_self():void
    {
        assertThat( _classUnderTest.onApproval( null ), strictlyEqualTo( _classUnderTest ) );
    }


    [Test]
    public function onApproval_maps_guard_classes_to_CommandMap_and_retains_order():void
    {
        _classUnderTest.onApproval( GrumpyGuard, HappyGuard, JoyfulGuard )
        assertThat( _classUnderTest.currentCommandGroup.guards,
                array(
                        strictlyEqualTo( GrumpyGuard ),
                        strictlyEqualTo( HappyGuard ),
                        strictlyEqualTo( JoyfulGuard )
                ) );
    }

    [Test]
    public function onApproval_pushes_currentCommandMap():void
    {
        _classUnderTest.onApproval( GrumpyGuard, HappyGuard, JoyfulGuard )
        assertThat( _classUnderTest.executionData[0], strictlyEqualTo( _classUnderTest.currentCommandGroup ) );
    }

    [Test]
    public function chaining_execute_and_onApproval_retains_commandClasses():void
    {
        _classUnderTest
                .executeAll( MockCommandOne, MockCommandThree, MockCommandTwo )
                .onApproval( GrumpyGuard, HappyGuard, JoyfulGuard );

        assertThat( _classUnderTest.currentCommandGroup.commands,
                array(
                        strictlyEqualTo( MockCommandOne ),
                        strictlyEqualTo( MockCommandThree ),
                        strictlyEqualTo( MockCommandTwo )
                ) );
    }

    [Test]
    public function chaining_onApproval_and_execute_retains_guardClasses():void
    {
        _classUnderTest
                .onApproval( GrumpyGuard, HappyGuard, JoyfulGuard )
                .executeAll( MockCommandOne, MockCommandThree, MockCommandTwo );

        assertThat( _classUnderTest.currentCommandGroup.guards,
                array(
                        strictlyEqualTo( GrumpyGuard ),
                        strictlyEqualTo( HappyGuard ),
                        strictlyEqualTo( JoyfulGuard )
                ) );
    }

    [Test]
    public function and_property_sets_currentCommandGroup_to_nulls():void
    {
        _classUnderTest
                .executeAll( MockCommandOne, MockCommandThree, MockCommandTwo )
                .and;

        assertThat( _classUnderTest.currentCommandGroup, nullValue() );
    }

    [Test]
    public function or_property_sets_currentCommandGroup_to_nulls():void
    {
        _classUnderTest
                .executeAll( MockCommandOne, MockCommandThree, MockCommandTwo )
                .or;

        assertThat( _classUnderTest.currentCommandGroup, nullValue() );
    }

    [Test]
    public function first_option_approved_executes_first_option_only():void
    {
        _classUnderTest
                .executeAll( MockCommandThree ).onApproval( HappyGuard )
                .or.executeAll( MockCommandOne ).onApproval( HappyGuard )
                .or.executeAll( MockCommandTwo );

        _classUnderTest.execute();

        assertThat( _registeredClasses.length, equalTo( 1 ) );
        assertThat( _registeredClasses[0], strictlyEqualTo( MockCommandThree ) );


    }

    [Test]
    public function first_option_fails_executes_section_option_only():void
    {
        _classUnderTest
                .executeAll( MockCommandThree ).onApproval( GrumpyGuard )
                .or.executeAll( MockCommandOne ).onApproval( HappyGuard )
                .or.executeAll( MockCommandTwo );

        _classUnderTest.execute();

        assertThat( _registeredClasses.length, equalTo( 1 ) );
        assertThat( _registeredClasses[0], strictlyEqualTo( MockCommandOne ) );

    }

    [Test]
    public function first_two_options_fail_executes_third_option_only():void
    {
        _classUnderTest
                .executeAll( MockCommandThree ).onApproval( GrumpyGuard )
                .or.executeAll( MockCommandOne ).onApproval( GrumpyGuard )
                .or.executeAll( MockCommandTwo );

        _classUnderTest.execute();

        assertThat( _registeredClasses.length, equalTo( 1 ) );
        assertThat( _registeredClasses[0], strictlyEqualTo( MockCommandTwo ) );

    }


    public function register( c:Class ):void
    {
          _registeredClasses.push(c);
    }
}
}
