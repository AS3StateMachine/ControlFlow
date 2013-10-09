package statemachine.flow.impl
{
import org.hamcrest.assertThat;
import org.hamcrest.collection.array;
import org.hamcrest.core.not;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.hasPropertyWithValue;
import org.hamcrest.object.instanceOf;
import org.hamcrest.object.strictlyEqualTo;
import org.swiftsuspenders.Injector;

import statemachine.flow.api.Payload;

import statemachine.flow.builders.FlowMapping;
import statemachine.flow.builders.OptionalFlowMapping;
import statemachine.flow.builders.SimpleFlowMapping;
import statemachine.support.TestRegistry;
import statemachine.flow.impl.support.mappings.MockOptionFlowGroup;
import statemachine.flow.impl.support.mappings.MockSingleFlowGroup;

public class ControlFlowContainerTest implements TestRegistry
{
    private var _classUnderTest:ControlFlowContainer;
    private var _injector:Injector;
    private var _executables:Array;

    [Before]
    public function before():void
    {
        _executables = [];
        _injector = new Injector();
        _classUnderTest = new ControlFlowContainer( _injector );
        _injector.map( FlowMapping ).toValue( _classUnderTest );
        _injector.map( TestRegistry ).toValue( this );
        _injector.map( SimpleControlFlow ).toType( MockSingleFlowGroup );
        _injector.map( OptionalControlFlow ).toType( MockOptionFlowGroup );
    }

    [After]
    public function after():void
    {
        _executables = null;
        _classUnderTest = null;
        _injector.teardown();
        _injector = null;

    }


    [Test]
    public function constructor_creates_childInjector():void
    {
        assertThat( _classUnderTest.injector.parentInjector, strictlyEqualTo( _injector ) );
    }

    [Test]
    public function constructor_maps_ControlFlowMapping_to_self_in_childInjector():void
    {
        assertThat( _classUnderTest.injector.getInstance( FlowMapping ), strictlyEqualTo( _classUnderTest ) );
    }

    [Test]
    public function always_property_returns_instanceOf_SingleFlowMapping():void
    {
        assertThat( _classUnderTest.always, instanceOf( SimpleFlowMapping ) )
    }

    [Test]
    public function always_property_returns_unique_instanceOf_SingleFlowMapping():void
    {
        assertThat( _classUnderTest.always, not( _classUnderTest.always ) )
    }

    [Test]
    public function SingleFlowMapping_instance_added_to_groups():void
    {
        assertThat( _classUnderTest.always, strictlyEqualTo( _classUnderTest.blocks[0] ) )
    }

    [Test]
    public function either_property_returns_instanceOf_CaseFlowMapping():void
    {
        assertThat( _classUnderTest.either, instanceOf( OptionalFlowMapping ) )
    }

    [Test]
    public function either_property_returns_unique_instanceOf_CaseFlowMapping():void
    {
        assertThat( _classUnderTest.either, not( _classUnderTest.either ) )
    }

    [Test]
    public function CaseFlowMapping_instance_added_to_groups():void
    {
        assertThat( _classUnderTest.either, strictlyEqualTo( _classUnderTest.blocks[0] ) )
    }

    [Test]
    public function execute_iterates_through_executables():void
    {
        _classUnderTest
                .either
                .and.always
                .and.either;

        _classUnderTest.executeBlock( null );

        assertThat( _executables.length, equalTo( 3 ) )
        assertThat(
                _executables
                , array(
                        instanceOf( MockOptionFlowGroup ),
                        instanceOf( MockSingleFlowGroup ),
                        instanceOf( MockOptionFlowGroup )
                ) );
    }
    [Test]
    public function execute_passes_payload_to_executables():void
    {
        _classUnderTest
                .either
                .and.always
                .and.either;

        const payload:Payload = new Payload()
        _classUnderTest.executeBlock( payload );

        assertThat( _executables.length, equalTo( 3 ) )
        assertThat(
                _executables
                , array(
                        hasPropertyWithValue( "receivedPayload", strictlyEqualTo(payload) ),
                        hasPropertyWithValue( "receivedPayload", strictlyEqualTo(payload) ),
                        hasPropertyWithValue( "receivedPayload", strictlyEqualTo(payload) )
                ) );
    }



    public function register( value:* ):void
    {
        _executables.push( value );
    }
}
}
